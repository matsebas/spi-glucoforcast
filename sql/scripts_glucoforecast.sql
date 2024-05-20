create database glucoforecast;

use glucoforecast;

-- DDL
-- Creación de tablas
create table usuarios (
    id bigint auto_increment primary key,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    email varchar(255) not null unique,
    telefono varchar(20),
    tipo enum('PACIENTE', 'CUIDADOR', 'MEDICO') not null
);

create table pacientes (
    id bigint primary key,
    fecha_nacimiento date,
    peso_corporal double,
    fecha_diagnostico date,
    constraint fk_paciente_usuario foreign key (id) references usuarios(id)
);

create table cuidadores (
    id bigint primary key,
    constraint fk_cuidador_usuario foreign key (id) references usuarios(id)
);

create table medicos (
    id bigint primary key,
    institucion varchar(255),
    constraint fk_medico_usuario foreign key (id) references usuarios(id)
);

create table paciente_cuidador (
    paciente_id bigint,
    cuidador_id bigint,
    primary key (paciente_id, cuidador_id),
    constraint fk_paciente foreign key (paciente_id) references pacientes(id),
    constraint fk_cuidador foreign key (cuidador_id) references cuidadores(id)
);

create table mediciones (
    id bigint auto_increment primary key,
    paciente_id bigint not null,
    fecha_hora datetime not null,
    glucemia double not null,
    carbohidratos double,
    insulina_comida double,
    insulina_correccion double,
    descripcion_comida varchar(255),
    insulina_lenta double,
    notas varchar(255),
    tags varchar(255),
    constraint fk_medicion_paciente foreign key (paciente_id) references pacientes(id)
);

create table estimaciones_glicosiladas (
    id bigint auto_increment primary key,
    paciente_id bigint not null,
    valor_calculado double not null,
    fecha_calculo datetime not null,
    constraint fk_estimacion_paciente foreign key (paciente_id) references pacientes(id)
);

create table reportes (
    id bigint auto_increment primary key,
    paciente_id bigint not null,
    tipo_reporte enum(
        'TENDENCIAS_GLUCEMIA', 'PATRONES_GLUCEMIA',
        'RANGOS_GLUCEMIA', 'PROMEDIOS_GLUCEMIA', 'HB1AC_HISTORICO',
        'DOSIFICACION_INSULINA', 'CANTIDAD_CARBOHIDRATOS',
        'NOTAS_OBSERVACIONES') not null,
    datos blob,
    fecha_generacion datetime not null,
    constraint fk_reporte_paciente foreign key (paciente_id) references pacientes(id)
);

-- DML
-- Inserción de datos en la tabla usuarios
insert into usuarios (id, nombre, apellido, email, telefono, tipo) values
(1, 'Lionel', 'Messi', 'lionel.messi@gmail.com', '123456789', 'PACIENTE'),
(2, 'Angel', 'Di Maria', 'angel.dimaria@gmail.com', '234567890', 'PACIENTE'),
(3, 'Emiliano', 'Martinez', 'emiliano.martinez@gmail.com', '345678901', 'PACIENTE'),
(4, 'Rodrigo', 'De Paul', 'rodrigo.depaul@gmail.com', '456789012', 'PACIENTE'),
(5, 'Julian', 'Alvarez', 'julian.alvarez@gmail.com', '567890123', 'PACIENTE'),
(6, 'Jose', 'Perez', 'jose.perez@gmail.com', '678901234', 'MEDICO'),
(7, 'Maria', 'Lopez', 'maria.lopez@hotmail.com', '789012345', 'CUIDADOR'),
(8, 'Juan', 'Garcia', 'juan.garcia@hotmail.com', '890123456', 'CUIDADOR');

-- Inserción de datos en la tabla pacientes
insert into pacientes (id, fecha_nacimiento, peso_corporal, fecha_diagnostico) values
(1, '2010-06-24', 35.5, '2015-06-24'),
(2, '2012-02-14', 40.0, '2016-02-14'),
(3, '2011-09-02', 45.0, '2017-09-02'),
(4, '2009-05-24', 50.5, '2014-05-24'),
(5, '2015-01-31', 30.0, '2019-01-31');

-- Inserción de datos en la tabla medicos
insert into medicos (id, institucion) values
(6, 'Hospital Nacional');

-- Inserción de datos en la tabla cuidadores
insert into cuidadores (id) values
(7),
(8);

-- Inserción de datos en la tabla paciente_cuidador
insert into paciente_cuidador (paciente_id, cuidador_id) values
(1, 7),
(2, 7),
(3, 8),
(4, 8),
(5, 8);

-- Inserción de datos en la tabla mediciones
insert into mediciones (id, paciente_id, fecha_hora, glucemia, carbohidratos,
                        insulina_comida, insulina_correccion, descripcion_comida,
                        insulina_lenta, notas, tags)
values
-- Mediciones para Lionel Messi
(1, 1, '2024-04-01 08:00:00', 85, 30, 2, 1, 'Desayuno', 0, 'Normal', 'DESAYUNO'),
(2, 1, '2024-04-02 12:00:00', 150, 50, 4, 2, 'Almuerzo', 0, 'Normal', 'ALMUERZO'),
(3, 1, '2024-04-03 18:00:00', 190, 60, 5, 2, 'Cena', 0, 'Hiperglucemia', 'CENA'),
(4, 1, '2024-04-04 22:00:00', 70, 20, 1, 0, 'Merienda', 0, 'Normal', 'MERIENDA'),
(5, 1, '2024-04-05 23:00:00', 60, 10, 0, 0, 'Snack', 0, 'Hipoglucemia', 'ANTES_DE_COMER'),
-- Mediciones para Angel Di Maria
(6, 2, '2024-04-01 08:00:00', 110, 20, 2, 1, 'Desayuno', 0, 'Normal', 'DESAYUNO'),
(7, 2, '2024-04-02 12:00:00', 175, 55, 4, 2, 'Almuerzo', 0, 'Normal', 'ALMUERZO'),
(8, 2, '2024-04-03 18:00:00', 200, 70, 6, 3, 'Cena', 0, 'Hiperglucemia', 'CENA'),
(9, 2, '2024-04-04 22:00:00', 80, 30, 3, 1, 'Merienda', 0, 'Normal', 'MERIENDA'),
(10, 2, '2024-04-05 23:00:00', 65, 15, 0, 0, 'Snack', 0, 'Hipoglucemia', 'ANTES_DE_COMER'),
-- Mediciones para Emiliano Martinez
(11, 3, '2024-04-01 08:00:00', 130, 25, 3, 1, 'Desayuno', 0, 'Normal', 'DESAYUNO'),
(12, 3, '2024-04-02 12:00:00', 160, 45, 4, 2, 'Almuerzo', 0, 'Normal', 'ALMUERZO'),
(13, 3, '2024-04-03 18:00:00', 185, 65, 5, 2, 'Cena', 0, 'Hiperglucemia', 'CENA'),
(14, 3, '2024-04-04 22:00:00', 90, 20, 2, 1, 'Merienda', 0, 'Normal', 'MERIENDA'),
(15, 3, '2024-04-05 23:00:00', 50, 10, 0, 0, 'Snack', 0, 'Hipoglucemia', 'ANTES_DE_COMER'),
-- Mediciones para Rodrigo De Paul
(16, 4, '2024-04-01 08:00:00', 120, 30, 3, 1, 'Desayuno', 0, 'Normal', 'DESAYUNO'),
(17, 4, '2024-04-02 12:00:00', 140, 50, 4, 2, 'Almuerzo', 0, 'Normal', 'ALMUERZO'),
(18, 4, '2024-04-03 18:00:00', 195, 60, 5, 2, 'Cena', 0, 'Hiperglucemia', 'CENA'),
(19, 4, '2024-04-04 22:00:00', 75, 20, 1, 0, 'Merienda', 0, 'Normal', 'MERIENDA'),
(20, 4, '2024-04-05 23:00:00', 55, 10, 0, 0, 'Snack', 0, 'Hipoglucemia', 'ANTES_DE_COMER'),
-- Mediciones para Julian Alvarez
(21, 5, '2024-04-01 08:00:00', 100, 20, 2, 1, 'Desayuno', 0, 'Normal', 'DESAYUNO'),
(22, 5, '2024-04-02 12:00:00', 170, 40, 4, 2, 'Almuerzo', 0, 'Normal', 'ALMUERZO'),
(23, 5, '2024-04-03 18:00:00', 185, 55, 5, 2, 'Cena', 0, 'Hiperglucemia', 'CENA'),
(24, 5, '2024-04-04 22:00:00', 90, 25, 2, 1, 'Merienda', 0, 'Normal', 'MERIENDA'),
(25, 5, '2024-04-05 23:00:00', 65, 15, 0, 0, 'Snack', 0, 'Hipoglucemia', 'ANTES_DE_COMER');

-- Inserción de datos en la tabla estimaciones_glicosiladas
insert into estimaciones_glicosiladas (id, paciente_id, valor_calculado, fecha_calculo)
values
-- Estimaciones para Lionel Messi
(1, 1, 6.5, '2024-04-01'),
(2, 1, 7.1, '2024-05-01'),
(3, 1, 6.8, '2024-05-20'),
-- Estimaciones para Angel Di Maria
(4, 2, 7.0, '2024-04-01'),
(5, 2, 6.9, '2024-05-01'),
(6, 2, 7.2, '2024-05-20'),
-- Estimaciones para Emiliano Martinez
(7, 3, 6.8, '2024-04-01'),
(8, 3, 7.4, '2024-05-01'),
(9, 3, 7.0, '2024-05-20'),
-- Estimaciones para Rodrigo De Paul
(10, 4, 6.9, '2024-04-01'),
(11, 4, 7.0, '2024-05-01'),
(12, 4, 6.7, '2024-05-20'),
-- Estimaciones para Julian Alvarez
(13, 5, 7.1, '2024-04-01'),
(14, 5, 7.3, '2024-05-01'),
(15, 5, 7.0, '2024-05-20');


-- Inserción de datos en la tabla reportes
insert into reportes (id, paciente_id, tipo_reporte, datos, fecha_generacion) values
-- Reportes de Tendencias de Glucemia para Lionel Messi
(1, 1, 'TENDENCIAS_GLUCEMIA', '[{"tendencia": {"fecha": "2024-05-01", "valor": 140}}]', '2024-05-20'),
(2, 1, 'TENDENCIAS_GLUCEMIA', '[{"tendencia": {"fecha": "2024-05-15", "valor": 150}}]', '2024-05-20'),
-- Reportes de Patrones de Glucemia para Angel Di Maria
(3, 2, 'PATRONES_GLUCEMIA', '[{"patron": {"fecha": "2024-05-01", "valor": 200}}]', '2024-05-20'),
(4, 2, 'PATRONES_GLUCEMIA', '[{"patron": {"fecha": "2024-05-15", "valor": 180}}]', '2024-05-20'),
-- Reportes de Rangos de Glucemia para Emiliano Martinez
(5, 3, 'RANGOS_GLUCEMIA', '[{"rango": {"fecha": "2024-05-01", "valor": "70-180"}}]', '2024-05-20'),
(6, 3, 'RANGOS_GLUCEMIA', '[{"rango": {"fecha": "2024-05-15", "valor": "50-200"}}]', '2024-05-20'),
-- Reportes de Promedios de Glucemia para Rodrigo De Paul
(7, 4, 'PROMEDIOS_GLUCEMIA', '[{"promedio": {"fecha": "2024-05-01", "valor": 120}}]', '2024-05-20'),
(8, 4, 'PROMEDIOS_GLUCEMIA', '[{"promedio": {"fecha": "2024-05-15", "valor": 130}}]', '2024-05-20'),
-- Reportes de Hb1Ac Histórica para Julian Alvarez
(9, 5, 'HB1AC_HISTORICO', '[{"hb1ac": {"fecha": "2024-04-01", "valor": 6.5}}]', '2024-05-20'),
(10, 5, 'HB1AC_HISTORICO', '[{"hb1ac": {"fecha": "2024-05-01", "valor": 7.0}}]', '2024-05-20'),
-- Reportes de Mediciones de Insulina para Lionel Messi
(11, 1, 'DOSIFICACION_INSULINA', '[{"dosis": {"fecha": "2024-05-01", "valor": 8}}]', '2024-05-20'),
(12, 1, 'DOSIFICACION_INSULINA', '[{"dosis": {"fecha": "2024-05-15", "valor": 10}}]', '2024-05-20'),
-- Reportes de Cantidad de Carbohidratos para Angel Di Maria
(13, 2, 'CANTIDAD_CARBOHIDRATOS', '[{"carbohidratos": {"fecha": "2024-05-01", "valor": 50}}]', '2024-05-20'),
(14, 2, 'CANTIDAD_CARBOHIDRATOS', '[{"carbohidratos": {"fecha": "2024-05-15", "valor": 60}}]', '2024-05-20'),
-- Reportes de Notas y Observaciones para Emiliano Martinez
(15, 3, 'NOTAS_OBSERVACIONES', '[{"nota": {"fecha": "2024-05-01", "contenido": "Sensación de fatiga"}}]', '2024-05-20'),
(16, 3, 'NOTAS_OBSERVACIONES', '[{"nota": {"fecha": "2024-05-15", "contenido": "Mejor ánimo y energía"}}]', '2024-05-20');

-- PRUEBAS
-- Consulta para verificar los reportes generados por tipo y paciente:
select u.nombre as paciente_nombre, u.apellido as paciente_apellido, r.tipo_reporte, r.datos, r.fecha_generacion
from reportes r
         join pacientes p on r.paciente_id = p.id
         join usuarios u on p.id = u.id
order by u.nombre, r.tipo_reporte, r.fecha_generacion;

-- Consulta para verificar las estimaciones de HbA1c por paciente:
select u.nombre as paciente_nombre, u.apellido as paciente_apellido, e.valor_calculado, e.fecha_calculo
from estimaciones_glicosiladas e
         join pacientes p on e.paciente_id = p.id
         join usuarios u on p.id = u.id
order by u.nombre, e.fecha_calculo;

insert into reportes (paciente_id, tipo_reporte, datos, fecha_generacion) values
    (5, 'HB1AC_HISTORICO', '[{"hb1ac": {"fecha": "2024-04-01", "valor": 6.5}}]', '2024-05-20'),
(5, 'HB1AC_HISTORICO', '[{"hb1ac": {"fecha": "2024-05-01", "valor": 7.0}}]', '2024-05-20')

-- Script para eliminar los reportes de paciente con apellido 'Alvarez' y comprobar que se eliminaron correctamente:
delete
from reportes
where paciente_id in (select p.id
                      from pacientes p
                               join usuarios u on p.id = u.id
                      where u.apellido = 'Alvarez');

select u.nombre as paciente_nombre, u.apellido as paciente_apellido, r.tipo_reporte, r.datos, r.fecha_generacion
from reportes r
         join pacientes p on r.paciente_id = p.id
         join usuarios u on p.id = u.id
order by p.id, r.tipo_reporte, r.fecha_generacion;