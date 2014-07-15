struct faceMapInfo (ID, nbVerts, Verts)
struct vertMapInfo (ID, Pos)

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