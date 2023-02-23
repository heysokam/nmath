#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

#_____________________________
# Connector cables to all types
import ./types/vec    as vecType    ; export vecType
import ./types/bounds as boundsType ; export boundsType
import ./types/trf    as trfType    ; export trfType
#_____________________________


#_____________________________
# External: Type aliases
#____________________
import pkg/vmath
type Size * = UVec2
converter toIVec2 *(s :Size) :IVec2=  ivec2(s.x.int32, s.y.int32)

