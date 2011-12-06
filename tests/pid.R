library(Rffi)
gid_t = pid_t = uint64Type
cif = CIF(pid_t)

parent = callCIF(cif, "getppid")
cur = callCIF(cif, "getpid")


cur = callCIF(cif, "getgid")

cur = callCIF(cif, "geteuid")


cif = CIF(stringType)
callCIF(cif, "getlogin")


################
# Same as Sys.getenv()

getenv =
function(name)
{
   callCIF(CIF(stringType, stringType), "getenv", as.character(name), returnInputs = FALSE)
}

getenv("PATH")
getenv("R_HOME")
getenv("R_LIBS")
getenv("doesn'texist")

#
callCIF(CIF(stringType, list(sint32Type)), "ttyname", 0L)


