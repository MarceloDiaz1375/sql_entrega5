-- 1. Primera CTE: Limpieza y agrupación por Mes y Categoría
WITH ventas_mensuales AS (
    SELECT 
        -- Normalizamos la fecha al inicio de cada mes (Año-Mes)
        DATE_TRUNC('month', p.fecha_pedido)::DATE AS mes_venta,
        c.nombre_categoria AS categoria,
        SUM(dp.subtotal) AS venta_total_mes
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
    JOIN productos pr ON dp.producto_id = pr.producto_id
    JOIN categorias c ON pr.categoria_id = c.categoria_id
    WHERE p.estado = 'Completado' -- Consideramos únicamente pedidos completados
    GROUP BY DATE_TRUNC('month', p.fecha_pedido), c.nombre_categoria
),

-- 2. Segunda CTE: Aplicación de Window Functions para Rankings y Acumulados
metricas_ventana AS (
    SELECT 
        mes_venta,
        categoria,
        venta_total_mes,
        -- Ranking de la categoría dentro de cada mes según sus ventas (mayor a menor)
        RANK() OVER (PARTITION BY mes_venta ORDER BY venta_total_mes DESC) AS ranking_categoria,
        -- Running Total: Ventas acumuladas de la categoría a lo largo del tiempo
        SUM(venta_total_mes) OVER (PARTITION BY categoria ORDER BY mes_venta) AS venta_acumulada_categoria,
        -- Promedio histórico de ventas para esta misma categoría (para usar en el CASE WHEN)
        AVG(venta_total_mes) OVER (PARTITION BY categoria) AS promedio_historico_categoria
    FROM ventas_mensuales
)

-- 3. Consulta Principal (SELECT final): Lógica de negocio con CASE WHEN
SELECT 
    TO_CHAR(mv.mes_venta, 'YYYY-MM') AS mes,
    mv.categoria,
    ROUND(mv.venta_total_mes, 2) AS venta_total_mes,
    mv.ranking_categoria,
    ROUND(mv.venta_acumulada_categoria, 2) AS venta_acumulada_categoria,
    ROUND(mv.promedio_historico_categoria, 2) AS promedio_historico_categoria,
    -- Comparativa condicional: ¿La venta del mes está por encima o por debajo de su promedio histórico?
    CASE 
        WHEN mv.venta_total_mes >= mv.promedio_historico_categoria THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS rendimiento_mes
FROM metricas_ventana mv
ORDER BY mv.mes_venta DESC, mv.ranking_categoria ASC;