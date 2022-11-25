use MED4CHILDREN

create view V_Pediatra_Clinica
/*descripcion: Este view indica los hospitales en los que labora los pediatras,
permite saber al usuario en que hospitales podria atendenrse luego de sacar una cita medica con un pediatra*/
--Fecha 23/11/2022
--Alumno: Fernando Sotelo Ramon
/******************* CONSULTA BASICA *************************/
as
select [e].[Nombre_Pediatra], [d].[Nombre_Clinica] from
[dbo].Pediatra AS [e]
INNER JOIN [dbo].[Local_Clinica] AS [d]
ON [e].[ID_Local_Clinica] = [d].[ID_Local_Clinica]

select * from V_Pediatra_Clinica
select * from Paciente_Hijo


create procedure sp_actualizar_paciente
/*descripción: Con este procedure el usuario padre de familia podrá actualizar la información de su hijo que sera atendido.
Esto mantendrá al paciente con su información actualizada como sus alergias o edad.*/
--Fecha 23/11/2022
--Alumno: Fernando Sotelo Ramon
/************************ CONSULTA INTERMEDIA *******************************/
@ID_Paciente int,
@Nombre_Paciente varchar(50),
@Edad_Paciente int,
@DNI_Paciente varchar(8),
@Alergia_Paciente varchar(50),
@ID_Usuario int,
@modo char(1)
as
if @modo='M'
begin
UPDATE Paciente_Hijo SET Nombre_Paciente=@Nombre_Paciente,Edad_Paciente=@Edad_Paciente,DNI_Paciente=@DNI_Paciente,Alergia_Paciente=@Alergia_Paciente WHERE ID_Paciente=@ID_Paciente and ID_Usuario=@ID_Usuario
end
exec sp_actualizar_paciente @modo='M', @ID_Paciente='3', @Nombre_Paciente='Alonso Chavez',@Edad_Paciente='6',@DNI_Paciente='79888888',@Alergia_Paciente='Salbutamol', @ID_Usuario='3'


create procedure sp_info_cita
/* descripción: Con este procedure se podrá saber la información sobre la salud del paciente,
se podrá saber que sintomas padece, el nombre de la posible enfermedad y el posible medicamento que consumió.
--Fecha= 23/11/2022
--Alumno: Fernando Sotelo Ramon */
/****************************** CONSULTA INTERMEDIA ******************************/
as
select p.ID_Paciente, p.Nombre_Paciente, s.Sintoma_Paciente, e.Nombre_Enfermedad, e.Pre_Medicamento
from Paciente_Hijo p
inner join Sintoma s
on p.ID_Paciente = s.ID_Paciente
inner join Enfermedad e
on s.ID_Sintoma = e.ID_Enfermedad
order by p.ID_Paciente




Create view V_Paciente_Prioritys
/*Descricion: Los padres de familia al momento de ir a la clinica para su chequeo de sus hijos deberan 
estar asignados por los pediatras que esten especialidados para ciertas edades la cual se atenderá por prioridad
Feccha: 23/11/2013
Usuario: Cesar Alvaro Martinez Callupe
*/
/************* Basico ***********************/
as
select Nombre_Pediatra ,Especialidad_Adicional, Nombre_Paciente , Edad_Paciente 
from Usuario_Pacientes p
join Paciente_Hijo a on a.ID_Paciente = p.ID_Paciente
join Pediatra t on t.ID_Pediatra = p.ID_Paciente

select * from V_Paciente_Prioritys
order by Edad_Paciente 


create view V_Usuario_Sintoma_UCI
/*descripcion : Cuando el paciente presenta un sintoma, el software le va a mostrar la posible enfermedad 
que este padeciendo , si esta enfermedad es de categoria "grave" pues se sacará una cita con el pediatra para su chequeo*/
--Fecha : 23/11/2022
--Usuario : Cesar Alvaro Martinez Callupe 
/**************** Intermedio **************************/
as
select Nombre_Paciente ,Sintoma_Paciente,Nombre_Enfermedad,Categoria, Fecha_Cita
from  Paciente_Hijo p 
join Sintoma v on v.ID_Sintoma= p.ID_Paciente
join Enfermedad s on s.ID_Enfermedad = p.ID_Paciente
join Categoria_Enfermedad l on l.ID_Categoria_Enfermedad = p.ID_Paciente
join Cita_Medica g on g.ID_Cita = p.ID_Paciente
where Categoria = 'grave' 
select * from V_Usuario_Sintoma_UCI


Create Procedure SP_Update_Usuarios 
/*descripcion: Cuando el usuario desea realizar algun cambio en su cuenta ya sea el 
celular o lugar de donde vive podrá actualizar sin ningun problema
*/
--Fecha: 23/11/2022
--Usuario : Cesar Alvaro Martinez Callupe
/*************** INTERMEDIO ***************/
@ID_Usuario int,
@DNI_Usuario varchar(8),
@Nombre_Usuario varchar(50),
@Distrito_Usuario varchar(50),
@Edad_Usuario int,
@Correo_Usuario varchar(50),
@Celular_Usuario varchar(50),
@Login_id int
as
update Usuario_Padre
set
DNI_Usuario = @DNI_Usuario,
Nombre_Usuario = @Nombre_Usuario,
Distrito_Usuario = @Distrito_Usuario,
Edad_UsuariO = @Edad_UsuariO,
Correo_Usuario = @Correo_Usuario,
Celular_Usuario = @Celular_Usuario,
Login_id = @Login_id 
where
ID_Usuario = @ID_Usuario
	
Select * from Usuario_Padre

exec SP_Update_Usuarios '4','74176978','Cesar Martinez', 'Surco', '21', 'Cesar17@gmail.com', '943785417' , '4'


--Vista consulta básica
Create view V_Horario_Pediatras
--Descripcion: Vista donde se muestra la lista de las citas programadas para que los pediatras verifiquen en el horario que trabajarán,
--de esta manera, cada uno de los doctores se podrán organizar y tendrán mas efectividad a la hora
--de entrar a su consulta
--Fecha: 22/11/22
--Usuario: Hugo Gabriel Rojas Cuba
as
select Nombre_Pediatra, Fecha_Cita from Pediatra p
join Cita_Medica a on a.ID_Pediatra=p.ID_Pediatra


--Funciones consulta Intermedia
Create Function FN_Categoria
--Descripcion:En esta función muestra mediante unas condicion para indicar si el paciente
--debe tener una cita medica de manera obligatoria u opcional, de este modo, se prevendrá
--consecuencias grandes dependiendo si es grave o leve
--Fecha:23/11/22
--Usuario: Hugo Gabriel Rojas Cuba
(@myinput nvarchar(50))
RETURNS nvarchar(50)
Begin
If @myinput = 'grave'
Set @myinput = 'Cita-Obligatoria'
Else If @myinput = 'leve'
Set @myinput = 'Cita-Opcional'
Return @myinput
End

select Nombre_Paciente ,Sintoma_Paciente,Nombre_Enfermedad,dbo.FN_Categoria(Categoria) As Categoria, Fecha_Cita
from  Paciente_Hijo p 
join Sintoma v on v.ID_Sintoma= p.ID_Paciente
join Enfermedad s on s.ID_Enfermedad = p.ID_Paciente
join Categoria_Enfermedad l on l.ID_Categoria_Enfermedad = p.ID_Paciente
join Cita_Medica g on g.ID_Cita = p.ID_Paciente


--Procedure consulta Intermedio
Create Procedure SP_Buscar_Paciente_DatosCita
--Descripcion: En este procedimiento nos muestra de forma interactiva todos los datos
--mas importantes para tener una cita medica, de esta manera, se podrá buscar el paciente,
--y mostrará sus datos principales, como su padre o representante, edad del paciente,
--sintomas, posible enfermedad,nombre del pediatra, fecha de la cital,
--la clinica en la que se va atender y la categoria de enfermedad que tiene el
--paciente
--Fecha:23/11/22
--Usuario: Hugo Gabriel Rojas Cuba
@Nombre_Paciente varchar(50)
as
select Nombre_Usuario As Padres, Nombre_Paciente As Hijos, Edad_Paciente ,Sintoma_Paciente,Nombre_Enfermedad,Categoria,
Nombre_Pediatra, Nombre_Clinica, Fecha_Cita
from  Paciente_Hijo p 
join Sintoma v on v.ID_Sintoma= p.ID_Paciente
join Enfermedad s on s.ID_Enfermedad = p.ID_Paciente
join Categoria_Enfermedad l on l.ID_Categoria_Enfermedad = p.ID_Paciente
join Cita_Medica g on g.ID_Cita = p.ID_Paciente
join Usuario_Padre i on i.ID_Usuario=p.ID_Paciente
join Pediatra t on t.ID_Pediatra=p.ID_Paciente
join Local_Clinica c on c.ID_Local_Clinica=p.ID_Paciente
where Nombre_Paciente like @Nombre_Paciente

--example
Exec SP_Buscar_Paciente_DatosCita 'Emile Perez'

--Vista consulta básica
Create view V_Nombre_Usuario_y_Paciente
--Descripcion: Vista donde se muestra la lista de los nombres tanto del padre como del hijo para que los pediatras verifiquen con quien trabajarán y quien los va a acompañar,
--de esta manera, se podrán organizar y tendrán más efectividad a la hora de entrar a su consulta
--Fecha: 24/11/22
--Usuario: Renzo Marcello Repetto Martini
as
select Nombre_Paciente, Nombre_Usuario from Usuario_Padre a
join Paciente_Hijo b on a.ID_Usuario=b.ID_Usuario



----Funciones----INTERMEDIO
Create Function FN_Edad_Paciente
--Descripcion: En esta función se muestra mediante una condición para indicar si el paciente es de alto riesgo dependiendo de su edad,
--pues se tendrá preferencia a los menores de 5 años
--Fecha: 24/11/2022
--Usuario: Renzo Marcello Repetto Martini
(@myinput nvarchar(50))
RETURNS nvarchar(50)
Begin
If @myinput <= 5
Set @myinput = 'Alto Riesgo'
Else If @myinput > 5
Set @myinput = 'Bajo Riesgo'
Return @myinput
End



----Funciones----INTERMEDIO
Create Function FN_Nombre_Enfermedad
--Descripcion: En esta función se muestra mediante unas condicion si es necesario que el paciente y los padres se hagan una prueba Covid 
--Fecha: 24/11/2022
--Usuario: Renzo Marcello Repetto Martini
(@myinput nvarchar(50))
RETURNS nvarchar(50)
Begin
If @myinput = 'Covid-19'
Set @myinput = 'Si'
Else if @myinput != 'Covid-19'
Set @myinput = 'No'
Return @myinput
End
Select Nombre_Usuario, Nombre_Paciente, dbo.FN_Nombre_Enfermedad(Nombre_Enfermedad) as 'Prueba Necesaria'  from Enfermedad e
join Paciente_Hijo p on p.ID_Paciente = e.ID_Enfermedad
join Usuario_Padre r on r.ID_Usuario = e.ID_Enfermedad


--Básico--
Create view V_Sintoma_Frecuente
--Descripcion: Vista donde se muestra la lista de sintomas más frecuentes es los pacientes (Hijo)
--Fecha: 23/11/22
--Usuario: Valeria Milagros Caqui Pizarro
as
select Nombre_Paciente, Sintoma_Paciente from Paciente_Hijo p
join Sintoma a on a.ID_Paciente = p.ID_Paciente

select * from V_Sintoma_Frecuente


--Intermedio_1 Stored Procedure (Actualizar)--
Create Procedure SP_Update_InfoPediatra 
--Descripcion: Crear un procedimiento almacenado en donde el pediatra pueda actualizar y eliminar su información 
--Fecha: 23/11/2022
--Usuario: Valeria Milagros Caqui Pizarro

@ID_Pediatra int,
@Nombre_Pediatra varchar(50),
@Formacion_Pediatra varchar(50),
@Especialidad_Adicional varchar(50),
@Dias_Laborables varchar(50),
@Login_id int,
@ID_Local_Clinica int
as
begin
update Pediatra
set
Nombre_Pediatra = @Nombre_Pediatra,
Formacion_Pediatra = @Formacion_Pediatra,
Especialidad_Adicional = @Especialidad_Adicional,
Dias_Laborables = @Dias_Laborables,
Login_id = @Login_id,
ID_Local_Clinica = @ID_Local_Clinica
where ID_Pediatra = @ID_Pediatra
end

Select * from Pediatra

exec SP_Update_InfoPediatra '7', 'Marcos Carrasco', 'Catolica', 'Oftalmología', 'Viernes/Sabado/Domingo', '2', '5'

DELETE FROM Pediatra WHERE Nombre_Pediatra = 'Marcos Carrasco'


-- Intermedio2
create view V_Cita_Paciente
--Descripcion: Crear una vista en la cual se observe las citas medicas reservados por los usuarios(pacientes) y visualizar el pediatra a cargo de la cita 
--Fecha: 23/11/2022
--Usuario: Valeria Milagros Caqui Pizarro
as
select ID_Cita, ID_Pediatra, Nombre_Pediatra
from Usuario_Pacientes u
join Cita_Medica c on c.ID_Cita = u.ID_Paciente
join Pediatra p on p.ID_Pediatra = c.ID_Pediatra
where Cita_Medica = 'Alan Park'

select * from V_Cita_Paciente


--Vista consulta básica
Create view V_Enfermedad_Possible
/* Mostrar los sintomas en comun de una serie de posibles enfermedades
   Fecha: 23/11/2022
   Usuario: Ramiro Sebastian Garcia Cardenas*/
as
select Sintoma_Paciente from Sintoma p
join Enfermedad a on a.ID_Enfermedad=p.ID_Sintoma


--Procedure Nivel Intermedio
/* Conforme avanzan los estudios sobre el tratamiento para diversas enfermedades,
   las clinicas necesitan actualizar los premedicamentos para sus pacientes
   Fecha: 24/11/2022
   Usuario: Ramiro Sebastián García Cárdenas */

Create Procedure SP_Update_PreMedicamentos
@ID_Enfermedad int,
@Nombre_Enfermedad varchar(50),
@Pre_Medicamento varchar(50)
as
update Enfermedad
set
Nombre_Enfermedad = @Nombre_Enfermedad,
Pre_Medicamento = @Pre_Medicamento
where ID_Enfermedad = @ID_Enfermedad

Select * from Enfermedad

exec SP_Update_PreMedicamentos '1', 'Covid-19', 'Ivermectina'


--Procedure Nivel Intermedio
/* Procedure donde se actualizará información vital sobre el paciente para un
   correcto diagnostico y mejorar la atención en la cita médica en base a la
   informacion nueva.
   Fecha: 24/11/2022
   Usuario: Ramiro Sebastián García Cárdenas */

Create Procedure SP_Update_InformacionPaciente
@ID_Paciente int,
@Nombre_Paciente varchar(50),
@Edad_Paciente int,
@DNI_Paciente varchar(8),
@Alergia_Paciente varchar(50),
@ID_Usuario int
as
update Paciente_Hijo
set
Nombre_Paciente = @Nombre_Paciente,
Edad_Paciente = @Edad_Paciente,
DNI_Paciente = @DNI_Paciente,
Alergia_Paciente = @Alergia_Paciente,
ID_Usuario = @ID_Usuario
where ID_Paciente = @ID_Paciente

Select * from Paciente_Hijo

exec SP_Update_InformacionPaciente '2', 'Alan Chavez', '18', '75082400', 'Ivermectina y Chocolate', '2'
