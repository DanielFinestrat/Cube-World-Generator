-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- INICIALIZACION ///////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
delete objects
free objects
try(destroyDialog generador) catch()

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- VARIABLES  /////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- GENERALES
tipoMundo = 1 -- Densidad de 1 a 3: Luna(1), Marte(2) y Jupiter(3).

tamX = 25
tamY = 25
tamMaxZ = 25
sueloarray = #(#()) -- Array de bloques donde debe ir el suelo

numRocas = 20

numMontañas = 10
tmñBaseMontañas = 20
alturaMontañas = 20

-- VARIABLES DE CONSTRUCCIONES
mayaCantidad = 3
mayaEscalones = 100
mayaTmñBase = 10
mayaAltura = 10

egipciaCantidad = 3
egipciaTmñBase = 10
egipciaAltura = 10

tailandesaCantidad = 3
tailandesaEscalones = 100
tailandesaTmñBase = 10
tailandesaAltura = 10

puenteCantidad = 5
puenteLongitud = 3
puenteAncho = 1
arcosPuente = 2

ruinaCantidad = 5
tmñBaseRuinas = 5

-- VARIABLES DE VEGETACION
numBosques = 3 --Número de bosques, cada uno con la misma densidad.
densidad = 2 -- Densidad de 1 a 4, poca a extrema.

-- TEXTURAS
texturaSueloRuta = sysInfo.currentdir + "\\texturas\luna.jpg"
texturaLunaRuta = sysInfo.currentdir + "\\texturas\luna.jpg"
texturaMarteRuta = sysInfo.currentdir + "\\texturas\marte.jpg"
texturaJupiterRuta = sysInfo.currentdir + "\\texturas\jupiter.jpg"

-- MATERIALES
matSuelo = StandardMaterial()
bitmapSuelo = bitmaptexture filename: texturaSueloRuta
matSuelo.diffusemap = bitmapSuelo
matSuelo.showInViewport = on

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- ROLLOUTS //////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
rollout generador "Generador de Mundos Minecraft" width:410 height:710(
	subRollout rollDentro "Dentro" pos:[5,10] width:400 height:700
)

rollout seleccionarMundo "Tipo de Mundo a Generar" width:296 height:104(
	radiobuttons radTipoDeMundo labels:#("Luna", "Marte", "Júpiter")
	on radTipoDeMundo changed param do(
		tipoMundo = radTipoDeMundo.state
		cambiarTexturaSuelo tipoMundo
	)
)

rollout tamañoMundo "Tamaño del Mundo" width:296 height:104(
	spinner spinTamX "Tamaño X" range:[25,200,25] type:#integer
	spinner spinTamY "Tamaño Y" range:[25,200,25] type:#integer
	spinner spinTamMaxZ "Tamaño Maximo Z" range:[25,200,25] type:#integer
	on spinTamX changed param do tamX = spinTamX.value
	on spinTamY changed param do tamY = spinTamY.value
	on spinTamMaxZ changed param do tamMaxZ = spinTamMaxZ.value
)

rollout piedras "Parametros sobre Rocas" width:296 height:104(
	spinner spinNumRocas "Número de Rocas" range:[0, 300, 20] type:#integer
	on spinNumRocas changed param do numRocas = spinNumRocas.value
)

rollout montañas "Parametros sobre Montañas" width:296 height:104(
	spinner spinNumMontañas "Número de Montañas" range:[0, 200, 10] type:#integer
	spinner spinTamBaseMont "Tamaño de la Base" range:[10, 100, 20] type:#integer
	spinner spinTamAlturaMont  "Altura de las Montañas" range:[10, 100, 20] type:#integer
	on spinNumMontañas changed param do numMontañas = spinNumMontañas.value
	on spinTamBaseMont changed param do tmñBaseMontañas = spinTamBaseMont.value
	on spinTamAlturaMont changed param do alturaMontañas = spinTamAlturaMont.value
)

rollout maya "Parametros sobre Piramides Maya" width:296 height:104(
	spinner spinCantidadMaya "Número de Piramides Maya" range:[0, 300, 3] type:#integer
	spinner spinEscalonesMaya "Número de Escalones" range:[100, 1000, 100] type:#integer
	spinner spinTamBaseMaya "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaMaya  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadMaya changed param do mayaCantidad = spinCantidadMaya.value
	on spinEscalonesMaya changed param do mayaEscalones = spinEscalonesMaya.value
	on spinTamBaseMaya changed param do mayaTmñBase = spinTamBaseMaya.value
	on spinTamAlturaMaya changed param do mayaAltura = spinTamAlturaMaya.value
)

rollout egipcia "Parametros sobre Piramides Egipcias" width:296 height:104(
	spinner spinCantidadEgipcia "Número de Piramides Egipcias" range:[0, 300, 3] type:#integer
	spinner spinTamBaseEgipcia "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaEgipcia  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadEgipcia changed param do egipciaCantidad = spinCantidadEgipcia.value
	on spinTamBaseEgipcia changed param do egipciaTmñBase = spinTamBaseEgipcia.value
	on spinTamAlturaEgipcia changed param do egipciaAltura = spinTamAlturaEgipcia.value
)

rollout tailandesa "Parametros sobre Piramides Tailandesas" width:296 height:104(
	spinner spinCantidadTailandesa "Número de Piramides Tailandesas" range:[0, 300, 3] type:#integer
	spinner spinEscalonesTailandesa "Número de Escalones" range:[10, 1000, 100] type:#integer
	spinner spinTamBaseTailandesa "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaTailandesa  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadTailandesa changed param do tailandesaCantidad = spinCantidadTailandesa.value
	on spinEscalonesTailandesa changed param do tailandesaEscalones = spinEscalonesTailandesa.value
	on spinTamBaseTailandesa changed param do tailandesaTmñBase = spinTamBaseTailandesa.value
	on spinTamAlturaTailandesa changed param do tailandesaAltura = spinTamAlturaTailandesa.value
)

rollout puentes "Parametros sobre Puentes" width:296 height:104(
	spinner spinCantidadPuentes "Número de Puentes" range:[0, 500, 5] type:#integer
	spinner spinLongPuente "Longitud del Puente" range:[5, 50, 5] type:#integer
	spinner spinAnchPuente "Ancho del Puente" range:[1, 10, 1] type:#integer
	spinner spinArcosPuente  "Arcos del Puente" range:[1, 20, 2] type:#integer
	on spinCantidadPuentes changed param do puenteCantidad = spinCantidadPuentes.value
	on spinLongPuente changed param do puenteLongitud = spinLongPuente.value
	on spinAnchPuente changed param do puenteAncho = spinAnchPuente.value
	on spinArcosPuente changed param do arcosPuente = spinArcosPuente.value
)

rollout ruinas "Parametros sobre las ruinas" width:296 height:104(
	spinner spinCantidadRuinas "Número de Ruinas" range:[0, 500, 5] type:#integer
	spinner spinTamRuinas "Tamaño de las Ruinas" range:[3, 50, 5] type:#integer
	on spinCantidadRuinas changed param do ruinaCantidad = spinCantidadRuinas.value
	on spinTamRuinas changed param do tmñBaseRuinas = spinTamRuinas.value
)

rollout vegetacion "Parametros sobre la Vegetacion" width:296 height:104(
	spinner spinNumBosques "Numero de Bosques" range:[0, 300, 3] type:#integer
	dropdownlist dropDensidad "Densidad de Bosques" items:#("Poca", "Normal", "Mucha", "Extrema") selection: 2 
	on spinNumBosques changed param do numBosques = spinNumBosques.value
	on dropDensidad selected changed do densidad = dropDensidad.selection
)

rollout generator "Generar Nuevo Mundo" width:296 height:104(
	button generar "Generar Nuevo Mundo"
	on generar pressed do (
		crearSuelo tamX tamY
		try(destroyDialog generador) catch())
)

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- FUNCIONES /////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
fn cambiarTexturaSuelo tipoMundo = (
	if tipoMundo == 1 then texturaSueloRuta = texturaLunaRuta
	else if tipoMundo == 2 then texturaSueloRuta = texturaMarteRuta
	else if tipoMundo == 3 then texturaSueloRuta = texturaJupiterRuta
	bitmapSuelo=bitmaptexture filename: texturaSueloRuta
	matSuelo.diffusemap = bitmapSuelo
)

fn crearSuelo tamX tamY = (
	empezarX = - (tamX/2)
	empezarY = - (tamY/2)
	acabarX = tamX/2
	acabarY = tamY/2
	for contX = empezarX to (acabarX)  do(
		for contY = empezarY to (acabarY) do(
			myBox = Box lengthsegs:1 widthsegs:1 heightsegs:1 length: 1 width:1 height:1 mapcoords:on pos:[contX, contY, 0]
			myBox.material = matSuelo
		)
	)
)

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- GENERAR MENÚ /////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
createdialog generador
AddSubRollout generador.rollDentro seleccionarMundo
AddSubRollout generador.rollDentro tamañoMundo
AddSubRollout generador.rollDentro piedras
AddSubRollout generador.rollDentro montañas
AddSubRollout generador.rollDentro maya
AddSubRollout generador.rollDentro egipcia
AddSubRollout generador.rollDentro tailandesa
AddSubRollout generador.rollDentro puentes
AddSubRollout generador.rollDentro ruinas
AddSubRollout generador.rollDentro vegetacion
AddSubRollout generador.rollDentro generator
