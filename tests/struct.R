library(Rffi)

 # manually define the type
rlimitType = structType(list(cur = uint64Type, max = uint64Type))

 # Create the CIF to call the 
cif = CIF(sint32Type, list(sint32Type, pointerType))

 # Create an instance of the rlimit structure as a pointer
ptr = alloc(rlimitType)

 # 3L is the stack
ans = callCIF(cif, "getrlimit", 3L, ptr, returnInputs = FALSE)

a = getStructField(ptr, "cur", rlimitType)
b = ptr$cur
c = ptr$max
