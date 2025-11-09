-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Sistema de Gestión de Materiales de Construcción
-- ============================================
-- Estas políticas garantizan que los usuarios solo puedan acceder
-- a los datos de su tienda asignada y según sus permisos de rol
--
-- IMPORTANTE: Este archivo debe ejecutarse DESPUÉS de supabase_schema_complete.sql
-- ============================================

-- ============================================
-- HABILITAR RLS EN TODAS LAS TABLAS
-- ============================================
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tiendas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.almacenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.unidades_medida ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.auditorias ENABLE ROW LEVEL SECURITY;

-- ============================================
-- FUNCIONES HELPER
-- ============================================

-- Obtener tienda del usuario actual
CREATE OR REPLACE FUNCTION get_user_tienda_id()
RETURNS UUID AS $$
    SELECT tienda_id 
    FROM public.usuarios 
    WHERE auth_user_id = auth.uid() 
    AND activo = true
    LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

COMMENT ON FUNCTION get_user_tienda_id() IS 'Retorna el ID de tienda del usuario autenticado';

-- Verificar si el usuario tiene un rol específico
CREATE OR REPLACE FUNCTION user_has_role(role_name TEXT)
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.usuarios u
        JOIN public.roles r ON u.rol_id = r.id
        WHERE u.auth_user_id = auth.uid()
        AND r.nombre = role_name
        AND u.activo = true
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

COMMENT ON FUNCTION user_has_role(TEXT) IS 'Verifica si el usuario tiene un rol específico';

-- Verificar si usuario es admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT user_has_role('Administrador');
$$ LANGUAGE sql SECURITY DEFINER STABLE;

COMMENT ON FUNCTION is_admin() IS 'Verifica si el usuario es administrador';

-- Verificar si usuario es gerente
CREATE OR REPLACE FUNCTION is_manager()
RETURNS BOOLEAN AS $$
    SELECT user_has_role('Gerente') OR is_admin();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

COMMENT ON FUNCTION is_manager() IS 'Verifica si el usuario es gerente o admin';

-- ============================================
-- POLÍTICAS: roles (lectura para todos autenticados)
-- ============================================
CREATE POLICY "Usuarios autenticados pueden leer roles"
    ON public.roles FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Solo admin puede modificar roles"
    ON public.roles FOR ALL
    TO authenticated
    USING (is_admin())
    WITH CHECK (is_admin());

-- ============================================
-- POLÍTICAS: tiendas
-- ============================================
CREATE POLICY "Usuarios autenticados pueden ver tiendas activas"
    ON public.tiendas FOR SELECT
    TO authenticated
    USING (activo = true AND deleted_at IS NULL);

CREATE POLICY "Solo admin puede crear tiendas"
    ON public.tiendas FOR INSERT
    TO authenticated
    WITH CHECK (is_admin());

CREATE POLICY "Solo admin puede actualizar tiendas"
    ON public.tiendas FOR UPDATE
    TO authenticated
    USING (is_admin())
    WITH CHECK (is_admin());

CREATE POLICY "Solo admin puede eliminar tiendas"
    ON public.tiendas FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: usuarios
-- ============================================
CREATE POLICY "Usuarios pueden ver su propia información"
    ON public.usuarios FOR SELECT
    TO authenticated
    USING (auth_user_id = auth.uid());

CREATE POLICY "Gerentes pueden ver usuarios de su tienda"
    ON public.usuarios FOR SELECT
    TO authenticated
    USING (
        (tienda_id = get_user_tienda_id() AND is_manager())
        OR is_admin()
    );

CREATE POLICY "Solo admin puede crear usuarios"
    ON public.usuarios FOR INSERT
    TO authenticated
    WITH CHECK (is_admin());

CREATE POLICY "Usuarios pueden actualizar su perfil"
    ON public.usuarios FOR UPDATE
    TO authenticated
    USING (auth_user_id = auth.uid())
    WITH CHECK (
        auth_user_id = auth.uid() 
        AND rol_id = (SELECT rol_id FROM public.usuarios WHERE auth_user_id = auth.uid())
    );

CREATE POLICY "Admin puede actualizar cualquier usuario"
    ON public.usuarios FOR UPDATE
    TO authenticated
    USING (is_admin())
    WITH CHECK (is_admin());

-- ============================================
-- POLÍTICAS: almacenes
-- ============================================
CREATE POLICY "Usuarios ven almacenes de su tienda"
    ON public.almacenes FOR SELECT
    TO authenticated
    USING (
        tienda_id = get_user_tienda_id()
        OR is_admin()
    );

CREATE POLICY "Gerentes pueden crear almacenes en su tienda"
    ON public.almacenes FOR INSERT
    TO authenticated
    WITH CHECK (
        (tienda_id = get_user_tienda_id() AND is_manager())
        OR is_admin()
    );

CREATE POLICY "Gerentes pueden actualizar almacenes de su tienda"
    ON public.almacenes FOR UPDATE
    TO authenticated
    USING (
        (tienda_id = get_user_tienda_id() AND is_manager())
        OR is_admin()
    );

CREATE POLICY "Solo admin puede eliminar almacenes"
    ON public.almacenes FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: categorias (lectura para todos)
-- ============================================
CREATE POLICY "Todos pueden leer categorías activas"
    ON public.categorias FOR SELECT
    TO authenticated
    USING (activo = true);

CREATE POLICY "Solo admin puede gestionar categorías"
    ON public.categorias FOR ALL
    TO authenticated
    USING (is_admin())
    WITH CHECK (is_admin());

-- ============================================
-- POLÍTICAS: unidades_medida (lectura para todos)
-- ============================================
CREATE POLICY "Todos pueden leer unidades de medida"
    ON public.unidades_medida FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Solo admin puede gestionar unidades"
    ON public.unidades_medida FOR ALL
    TO authenticated
    USING (is_admin())
    WITH CHECK (is_admin());

-- ============================================
-- POLÍTICAS: proveedores
-- ============================================
CREATE POLICY "Todos pueden leer proveedores activos"
    ON public.proveedores FOR SELECT
    TO authenticated
    USING (activo = true AND deleted_at IS NULL);

CREATE POLICY "Gerentes pueden crear proveedores"
    ON public.proveedores FOR INSERT
    TO authenticated
    WITH CHECK (is_manager());

CREATE POLICY "Gerentes pueden actualizar proveedores"
    ON public.proveedores FOR UPDATE
    TO authenticated
    USING (is_manager());

CREATE POLICY "Solo admin puede eliminar proveedores"
    ON public.proveedores FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: productos
-- ============================================
CREATE POLICY "Todos pueden leer productos activos"
    ON public.productos FOR SELECT
    TO authenticated
    USING (activo = true AND deleted_at IS NULL);

CREATE POLICY "Gerentes pueden crear productos"
    ON public.productos FOR INSERT
    TO authenticated
    WITH CHECK (is_manager());

CREATE POLICY "Gerentes pueden actualizar productos"
    ON public.productos FOR UPDATE
    TO authenticated
    USING (is_manager());

CREATE POLICY "Solo admin puede eliminar productos"
    ON public.productos FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: lotes
-- ============================================
CREATE POLICY "Todos pueden leer lotes"
    ON public.lotes FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Usuarios autorizados pueden crear lotes"
    ON public.lotes FOR INSERT
    TO authenticated
    WITH CHECK (is_manager());

CREATE POLICY "Usuarios autorizados pueden actualizar lotes"
    ON public.lotes FOR UPDATE
    TO authenticated
    USING (is_manager());

CREATE POLICY "Solo admin puede eliminar lotes"
    ON public.lotes FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: inventarios
-- ============================================
CREATE POLICY "Usuarios ven inventarios de su tienda"
    ON public.inventarios FOR SELECT
    TO authenticated
    USING (
        tienda_id = get_user_tienda_id()
        OR is_admin()
    );

CREATE POLICY "Usuarios pueden crear inventarios en su tienda"
    ON public.inventarios FOR INSERT
    TO authenticated
    WITH CHECK (
        tienda_id = get_user_tienda_id()
        OR is_admin()
    );

CREATE POLICY "Usuarios pueden actualizar inventarios de su tienda"
    ON public.inventarios FOR UPDATE
    TO authenticated
    USING (
        tienda_id = get_user_tienda_id()
        OR is_admin()
    );

-- ============================================
-- POLÍTICAS: movimientos
-- ============================================
CREATE POLICY "Usuarios ven movimientos de su tienda"
    ON public.movimientos FOR SELECT
    TO authenticated
    USING (
        tienda_origen_id = get_user_tienda_id()
        OR tienda_destino_id = get_user_tienda_id()
        OR is_admin()
    );

CREATE POLICY "Usuarios pueden crear movimientos desde su tienda"
    ON public.movimientos FOR INSERT
    TO authenticated
    WITH CHECK (
        tienda_origen_id = get_user_tienda_id()
        OR is_admin()
    );

CREATE POLICY "Usuarios pueden actualizar movimientos de su tienda"
    ON public.movimientos FOR UPDATE
    TO authenticated
    USING (
        (tienda_origen_id = get_user_tienda_id() OR tienda_destino_id = get_user_tienda_id())
        OR is_admin()
    );

CREATE POLICY "Solo admin puede eliminar movimientos"
    ON public.movimientos FOR DELETE
    TO authenticated
    USING (is_admin());

-- ============================================
-- POLÍTICAS: auditorias (solo lectura para admin)
-- ============================================
CREATE POLICY "Solo admin puede leer auditorías"
    ON public.auditorias FOR SELECT
    TO authenticated
    USING (is_admin());

CREATE POLICY "Sistema puede insertar auditorías"
    ON public.auditorias FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- ============================================
-- VERIFICACIÓN DE POLÍTICAS
-- ============================================
-- Ejecuta esta query para verificar que todas las políticas se crearon correctamente

SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================
-- 1. Estas políticas asumen que existe un usuario autenticado (auth.uid())
-- 2. Las funciones helper usan SECURITY DEFINER para acceder a datos del sistema
-- 3. Los usuarios deben tener el campo auth_user_id vinculado a auth.users
-- 4. Para testing, puedes deshabilitar RLS temporalmente con:
--    ALTER TABLE nombre_tabla DISABLE ROW LEVEL SECURITY;
-- 5. Para producción, SIEMPRE mantén RLS habilitado
-- 6. Las políticas con 'TO authenticated' solo aplican a usuarios logueados
-- 7. Gerentes incluyen automáticamente permisos de admin en is_manager()
