-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- VARIABLES  /////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- GENERALES
tipoMundo = 1 -- Densidad de 1 a 3: Luna(1), Marte(2) y Jupiter(3).

tamX = 100
tamY = 100
tamMaxZ = 100
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

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- ROLLOUTS //////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
rollout generador "Generador de Mundos Minecraft" width:410 height:710(
	subRollout rollDentro "Dentro" pos:[5,10] width:400 height:700
)

rollout seleccionarMundo "Tipo de Mundo a Generar" width:296 height:104(
	radiobuttons radTipoDeMundo labels:#("Luna", "Marte", "Júpiter")
	button actualizarTipoMundo "Actualizar Tipo de Mundo"
	on actualizarTipoMundo pressed do tipoMundo = radTipoDeMundo.state
)

rollout tamañoMundo "Tamaño del Mundo" width:296 height:104(
	spinner spinTamX "Tamaño X" range:[100,10000,100] type:#integer
	spinner spinTamY "Tamaño Y" range:[100,10000,100] type:#integer
	spinner spinTamMaxZ "Tamaño Maximo Z" range:[100,10000,100] type:#integer
	button actualizarTamañoMundo "Actualizar Tamaño de Mundo"
	on actualizarTamañoMundo pressed do( 
		tamX = spinTamX.value
		tamY = spinTamY.value
		tamMaxZ = spinTamMaxZ.value
	)
)

rollout piedras "Parametros sobre Rocas" width:296 height:104(
	spinner spinNumRocas "Número de Rocas" range:[0, 300, 20] type:#integer
	button actualizarnumRocas "Actualizar Número de Rocas"
	on actualizarnumRocas pressed do numRocas = spinNumRocas.value
)

rollout montañas "Parametros sobre Montañas" width:296 height:104(
	spinner spinNumMontañas "Número de Montañas" range:[0, 200, 10] type:#integer
	spinner spinTamBaseMont "Tamaño de la Base" range:[10, 100, 20] type:#integer
	spinner spinTamAlturaMont  "Altura de las Montañas" range:[10, 100, 20] type:#integer
	button actualizarMontañas "Actualizar Montañas"
	on actualizarMontañas pressed do(
		numMontañas = spinNumMontañas.value
		tmñBaseMontañas = spinTamBaseMont.value
		alturaMontañas = spinTamAlturaMont.value
	)
)

rollout maya "Parametros sobre Piramides Maya" width:296 height:104(
	spinner spinCantidadMaya "Número de Piramides Maya" range:[0, 300, 3] type:#integer
	spinner spinEscalonesMaya "Número de Escalones" range:[100, 1000, 100] type:#integer
	spinner spinTamBaseMaya "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaMaya  "Altura de las piramides" range:[10, 100, 10] type:#integer
	button actualizarMaya "Actualizar Piramides Maya"
	on actualizarMaya pressed do(
		mayaCantidad = spinCantidadMaya.value
		mayaEscalones = spinEscalonesMaya.value
		mayaTmñBase = spinTamBaseMaya.value
		mayaAltura = spinTamAlturaMaya.value
	)
)

rollout egipcia "Parametros sobre Piramides Egipcias" width:296 height:104(
	spinner spinCantidadEgipcia "Número de Piramides Egipcias" range:[0, 300, 3] type:#integer
	spinner spinTamBaseEgipcia "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaEgipcia  "Altura de las piramides" range:[10, 100, 10] type:#integer
	button actualizarEgipcias "Actualizar Piramides Egipcias"
	on actualizarEgipcias pressed do(
		egipciaCantidad = spinCantidadEgipcia.value
		egipciaTmñBase = spinTamBaseEgipcia.value
		egipciaAltura = spinTamAlturaEgipcia.value
	)
)

rollout tailandesa "Parametros sobre Piramides Tailandesas" width:296 height:104(
	spinner spinCantidadTailandesa "Número de Piramides Tailandesas" range:[0, 300, 3] type:#integer
	spinner spinEscalonesTailandesa "Número de Escalones" range:[10, 1000, 100] type:#integer
	spinner spinTamBaseTailandesa "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaTailandesa  "Altura de las piramides" range:[10, 100, 10] type:#integer
	button actualizarTailandesas "Actualizar Piramides Tailandesas"
	on actualizarTailandesas pressed do(
		tailandesaCantidad = spinCantidadTailandesa.value
		tailandesaEscalones = spinEscalonesTailandesa.value
		tailandesaTmñBase = spinTamBaseTailandesa.value
		tailandesaAltura = spinTamAlturaTailandesa.value
	)
)

rollout puentes "Parametros sobre Puentes" width:296 height:104(
	spinner spinCantidadPuentes "Número de Puentes" range:[0, 500, 5] type:#integer
	spinner spinLongPuente "Longitud del Puente" range:[5, 50, 5] type:#integer
	spinner spinAnchPuente "Ancho del Puente" range:[1, 10, 1] type:#integer
	spinner spinArcosPuente  "Arcos del Puente" range:[1, 20, 2] type:#integer
	button actualizarPuentes "Actualizar Puentes"
	on actualizarPuentes pressed do(
		puenteCantidad = spinCantidadPuentes.value
		puenteLongitud = spinLongPuente.value
		puenteAncho = spinAnchPuente.value
		arcosPuente = spinArcosPuente.value
	)
)

rollout ruinas "Parametros sobre las ruinas" width:296 height:104(
	spinner spinCantidadRuinas "Número de Ruinas" range:[0, 500, 5] type:#integer
	spinner spinTamRuinas "Tamaño de las Ruinas" range:[3, 50, 5] type:#integer
	button actualizarRuinas "Actualizar Ruinas"
	on actualizarRuinas pressed do(
		ruinaCantidad = spinCantidadRuinas.value
		tmñBaseRuinas = spinTamRuinas.value
	)
)

rollout vegetacion "Parametros sobre la Vegetacion" width:296 height:104(
	spinner spinNumBosques "Numero de Bosques" range:[0, 300, 3] type:#integer
	dropdownlist dropDensidad "Densidad de Bosques" items:#("Poca", "Normal", "Mucha", "Extrema") selection: 2 
	button actualizarBosques "Actualizar Bosques"
	on actualizarBosques pressed do(
		numBosques = spinNumBosques.value
		densidad = dropDensidad.selection
	)
)

rollout generator "Generar Nuevo Mundo" width:296 height:104(
	button generar "Generar Nuevo Mundo"
	on generar pressed do messageBox "TODO"
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
