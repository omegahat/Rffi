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


ans = sapply(0:8, function(res)  {
    ans = callCIF(cif, "getrlimit", as.integer(res), ptr, returnInputs = FALSE)
    ptr[c("cur", "max")]
})o

# on my macbookpro,
resMap = c("cpu"=0, "fsize"=1, "data"=2, "stack"=3,  "core"=4, "addressSpace"=5, "rss"=5, "memlock"=6, "nproc"=7, nofile=8)

colnames(ans) = names(resMap)[-7]
