#library(RGCCTranslationUnit)
#defs = getCppDefines("/usr/include/sys/resource.h", cpp = "gcc", sysIncludes = character())
#parseTU("resource.c.001t.tu")

library(Rffi)

 # manually define the type
rlimitType = structType(list(cur = uint64Type, max = uint64Type))

 # Create the CIF to call the 
cif = CIF(sint32Type, list(sint32Type, pointerType))

 # Create an instance of the rlimit structure as a pointer
ptr = alloc(rlimitType)

ans = callCIF(cif, "getrlimit", 0L, ptr, returnInputs = FALSE)

ptr$cur

 # These are the resource numbers on OS X.
resources = c(CPU = 0L, FSIZE = 1L, DATA = 2L, STACK = 3L,
              CORE = 4L, ADDR_SPACE = 5L, RSS = 5L,
              MEMLOCK = 6L, NPROC = 7L, NOFILE = 8)
           

  # Get all the resources
Infty = 2^63 - 1

o = sapply(resources,
        function(r) {
            ans = callCIF(cif, "getrlimit", r, ptr, returnInputs = FALSE)
            tmp = c(getStructField(ptr, "cur", rlimitType),
                    getStructField(ptr, "max", rlimitType))
            tmp[tmp == Infty] = Inf # convert the local Infty to R's Inf
            tmp
          })

getrlimit =
function(what, ptr = alloc(rlimitType))
{
    ans = callCIF(cif, "getrlimit", as.integer(what), ptr, returnInputs = FALSE)
    if(ans != 0)
      stop("an error occurred in the native getrlimit for ", what)
    tmp = c(cur = getStructField(ptr, "cur", rlimitType),
            max = getStructField(ptr, "max", rlimitType))
    tmp[tmp == Infty] = Inf # convert the local Infty to R's Inf
    tmp
}


rm(ptr)
gc()



