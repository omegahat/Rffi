library(RGCCTranslationUnit)
 # read the TU file
tu = parseTU("../TU/test.c.001t.tu")
 # find only the routines in files that start with test
r = getRoutines(tu, "test")
 # get the routine of interest
f = r$runFunPtr
 # resolve all the data types referenced in the routine
f = resolveType(f, tu)

 # Verify the types interactively
sapply(f$parameters, class)
sapply(f$parameters, function(x) class(x$type))

 # Get the function pointer type parameter
funPtr = f$parameters[["fun"]]$type
class(funPtr) == "FunctionPointer"

  # Now we generate the wrapper routine, sourceing the function to do this
  # and then invoking it with the relevant arguments.
source("funPtrTU.R")
code = createCallRFunctionWrapper(funPtr, "R_myFun2", 2, paramNames = c("value", "userData"))
  # Write the generated code along with the necessary C header files
cat("#include <Rdefines.h>",
    code,
    sep = "\n", file = "foo.c")


    # Compile the foo.c into a DSO
  system(sprintf("%s/bin/R CMD SHLIB foo.c", R.home()))

    # load the resulting DSO
  dyn.load("foo.so")
    # get a reference to the newly generated routine which we
    # can pass as the function pointer argument.
  f = getNativeSymbolInfo("R_myFun2")$address

     # Define the R function that will be called each iteration
  myFun = function(val)
               val + 1

    # Now we can invoke the original C routine and pass our function pointer - R_myFun2
    # and our R function - myFun. We create the CIF first and then invoke it.
  library(Rffi)
  cif = CIF(doubleType, list(sint32Type, doubleType, pointerType, pointerType), rep(FALSE, 4))

  ans = callCIF(cif, "runFunPtr", 3, pi, f, myFun)
  print(ans)

