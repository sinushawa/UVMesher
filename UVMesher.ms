struct faceMapInfo (ID, nbVerts, Verts)
struct vertMapInfo (ID, Pos)

holder = selection[1]

fn compareFN v1 v2 =
(
	local d = v1.ID-v2.ID
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)

nbFaces=selection[1].GetNumFaces()
faces=#()
allVertices=#()
IDs=#()
for i=1 to nbFaces do
(
	vertices=#()
	indices =polyop.getMapFace selection[1] 1 i
	for j in indices do
	(
		vertexPos=polyop.getMapVert selection[1] 1 j
		vertInfo = vertMapInfo ID:j Pos:vertexPos
		append vertices vertInfo
		res= appendifUnique IDs j
		if res==true then
		(
			append allvertices vertInfo
		)
	)
	faceInfo = faceMapInfo ID:i nbVerts:indices.Count Verts:vertices
	append faces faceInfo
)
makeUniqueArray allvertices
qsort allvertices compareFN
print allvertices
ep = editable_mesh name:(uniquename"EPoly") 
convertTo ep Editable_Poly
for i in allVertices do
(
	ep.createVertex i.Pos pointInLocalCoords:true select:false
)
for i in faces do
(
	indices=#()
	for j in i.Verts do
	(
		append indices j.ID
	)
	ep.createFace indices select:false
)

fn CallbackFn1 ev nd = 
(
	cond1 = (nd[1])
	cond2 = (((GetHandleByAnim ep) as Integer))
	if cond1 == cond2 then
	(
		changedVerts = polyop.getVertSelection ep
		changedVerts = changedVerts as array
		for Vert in changedVerts do
		(
			Pos = polyop.getVert ep Vert
			polyop.setMapVert holder 1 Vert Pos
		)
		un = Unwrap_UVW ()
		addmodifier holder un
		collapseStack holder
	)
)
callbackItem = NodeEventCallback mouseUp:true delay:1000 geometrychanged:CallbackFn1