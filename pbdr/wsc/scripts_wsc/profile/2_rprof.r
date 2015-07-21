x <- matrix( rnorm (10000 * 250) , nrow =10000 , ncol =250)

Rprof()
invisible( prcomp(x) )
Rprof( NULL )

summaryRprof()

Rprof( interval =.99 )
invisible( prcomp(x) )
Rprof( NULL )

summaryRprof()
