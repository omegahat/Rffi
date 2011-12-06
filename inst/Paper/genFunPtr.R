library(Rllvm)
InitializeNativeTarget()

  # Create a module to house the routine
mod = Module("OptimizeFunPtr")
voidPtr = pointerType(VoidType)

  # Define the function with its signature - return and input types
fun = Function("myFun", DoubleType, c(val = DoubleType, userData = voidPtr), mod)

 #
entry = Block(fun, "entry")
 
