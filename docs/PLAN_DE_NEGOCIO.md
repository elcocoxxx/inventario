# Plan de negocio — Inventario

**Software de gestión para barberías**

> Documento de trabajo. Las cifras marcadas como *supuesto* son ejemplos para ilustrar el modelo y deben validarse con entrevistas y pruebas reales antes de tomar decisiones.

---

## 1. Resumen ejecutivo

**Inventario** es una aplicación web y móvil que permite a una barbería llevar el control de clientes, barberos, servicios, productos, ventas, gastos e ingresos desde un solo lugar y en tiempo real.

Muchas barberías pequeñas manejan su negocio con cuadernos, mensajes o una hoja de cálculo. Eso provoca pérdidas de dinero por deudas olvidadas, inventario sin control y falta de claridad sobre cuánto genera cada barbero.

La propuesta es un software **simple, económico y en español**, pensado para el dueño de barbería que no es técnico, ofrecido por **suscripción mensual**.

## 2. Problema

| Problema | Consecuencia |
|---|---|
| Se anotan los cortes y ventas en cuadernos o de memoria | Errores, pérdidas y cuentas poco claras |
| No hay control de las deudas de clientes | Dinero que no se recupera |
| El inventario de productos no se actualiza | Se agota el stock o se compra de más |
| No se sabe cuánto genera cada barbero | Dificultad para liquidar pagos y comisiones |
| Gastos e ingresos mezclados | El dueño no sabe si el negocio realmente gana |

## 3. Solución y propuesta de valor

- **Todo en un solo lugar:** clientes, barberos, servicios, productos, ventas, caja y gastos.
- **Fácil de usar:** pantallas simples, diseño oscuro moderno, sin curva de aprendizaje larga.
- **En la nube:** los datos se guardan en Firebase y se ven desde el celular o el computador.
- **Control del dinero:** clientes con deuda, caja por barbero y registro de gastos e ingresos.
- **Costo bajo:** pensado para negocios que no pueden pagar un software empresarial.

## 4. Mercado objetivo

**Cliente principal:** dueños de barberías pequeñas y medianas (1 a 10 barberos).

**Mercado inicial:** Colombia, comenzando por la ciudad del equipo y por barberías conocidas.

**Segmentos futuros:** peluquerías, salones de belleza, centros de estética y spas.

*Por validar:* número real de barberías en la zona inicial y cuántas usan algún software hoy. Se puede estimar contando negocios en un mapa y entrevistando una muestra.

## 5. Competencia

| Alternativa | Fortalezas | Debilidades frente a Inventario |
|---|---|---|
| Cuaderno / Excel | Gratis y conocido | Sin tiempo real, propenso a errores, sin control de stock |
| Apps de agendamiento | Buenas para citas | Suelen no cubrir inventario, deudas y caja por barbero |
| Software POS genérico | Completo | Costoso y complejo para una barbería pequeña |

**Diferenciador:** enfoque específico en barberías, precio accesible y soporte cercano.

## 6. Modelo de ingresos

Suscripción mensual por barbería (precios en COP, *supuesto*):

| Plan | Precio mensual | Incluye |
|---|---|---|
| **Básico** | $29.900 | 1 a 2 barberos, clientes, servicios, cortes y ventas |
| **Pro** | $59.900 | Hasta 6 barberos, inventario, caja por barbero, gastos e ingresos, reportes |
| **Premium** | $99.900 | Barberos ilimitados, multi-sucursal, soporte prioritario |

Otras fuentes posibles: configuración inicial pagada, capacitación y personalización de marca.

**Estrategia de entrada:** 30 días de prueba gratis y descuento por pago anual.

## 7. Estrategia de marketing y ventas

1. **Boca a boca y visitas directas:** demostración de 10 minutos en la barbería, con la demo en línea.
2. **Redes sociales:** videos cortos mostrando el antes y después de llevar el negocio ordenado (Instagram, TikTok, Facebook).
3. **Alianzas:** distribuidores de productos de barbería y academias de barbería.
4. **Referidos:** un mes gratis por cada barbería que se recomiende.
5. **Prueba piloto:** 3 a 5 barberías que usen la app gratis a cambio de retroalimentación y testimonios.

## 8. Plan operativo

**Tecnología:** Flutter (una sola base de código para web, Android y escritorio), Firebase (autenticación y base de datos) y GitHub Pages para la demo.

**Equipo mínimo:** desarrollador (producto y soporte técnico), una persona para ventas y atención, y asesoría contable para temas tributarios.

**Soporte:** WhatsApp y videollamadas cortas para capacitar al dueño y a los barberos.

## 9. Costos e ingresos (ejemplo ilustrativo)

Todos los valores son *supuestos* para mostrar el cálculo.

| Concepto | Valor mensual (COP) |
|---|---|
| Hosting y base de datos (Firebase, según uso) | $50.000 |
| Dominio y herramientas | $30.000 |
| Marketing y transporte | $150.000 |
| Imprevistos y soporte | $70.000 |
| **Costos fijos totales** | **$300.000** |

**Costo variable por cliente:** ≈ $3.000/mes (*supuesto*, uso de base de datos y almacenamiento).

**Punto de equilibrio** con el plan Pro:

```
Margen por cliente = 59.900 − 3.000 = 56.900
Clientes necesarios = 300.000 / 56.900 ≈ 5,3  →  6 barberías
```

**Proyección simple a 12 meses** (*supuesto*, plan Pro, sin considerar abandono):

| Mes | Barberías | Ingreso mensual |
|---|---|---|
| 3 | 5 | $299.500 |
| 6 | 15 | $898.500 |
| 9 | 30 | $1.797.000 |
| 12 | 50 | $2.995.000 |

> Al crecer, el costo de Firebase y de soporte aumenta. Hay que recalcular con datos reales cada trimestre.

## 10. Análisis FODA

| | |
|---|---|
| **Fortalezas** | Producto ya funcionando, bajo costo de desarrollo, interfaz simple, multiplataforma |
| **Oportunidades** | Muchos negocios aún sin digitalizar, crecimiento del sector de barbería, expansión a otros salones |
| **Debilidades** | Producto nuevo y sin marca, equipo pequeño, depende de Firebase |
| **Amenazas** | Competidores con más recursos, negocios reacios al cambio, cambios en precios de la nube |

## 11. Riesgos y cómo reducirlos

| Riesgo | Mitigación |
|---|---|
| Los dueños no adoptan la herramienta | Capacitación personal y periodo de prueba gratis |
| Pérdida o filtración de datos | Reglas de seguridad de Firestore, copias de seguridad y acceso por usuario |
| Aumento del costo de la nube | Monitorear consumo y optimizar consultas |
| Dependencia de una sola persona | Documentar el proyecto y automatizar el despliegue |

## 12. Indicadores clave (KPIs)

- Barberías activas
- Ingreso mensual recurrente (MRR)
- Tasa de abandono mensual
- Costo de conseguir un cliente
- Barberías que pasan de prueba a pago

## 13. Hoja de ruta

| Etapa | Objetivo |
|---|---|
| **Fase 1 (0–2 meses)** | Pulir la app, reglas de seguridad, piloto con 3 a 5 barberías |
| **Fase 2 (3–6 meses)** | Roles y permisos, reportes PDF/Excel, primeros clientes de pago |
| **Fase 3 (7–12 meses)** | Agenda de citas, multi-sucursal, expansión a otras ciudades |

## 14. Necesidades para arrancar

- Validar el producto con barberías reales.
- Definir la figura legal y tributaria del negocio (con asesoría profesional).
- Política de privacidad y tratamiento de datos personales, ya que la app guarda datos de clientes.
- Un dominio propio y una marca (nombre y logo).

---

*Autor: OSCAR MAURICIO CAPERA Y MICHAEL VILLANUEVA NEIRA · Proyecto: github.com/elcocoxxx/inventario*
