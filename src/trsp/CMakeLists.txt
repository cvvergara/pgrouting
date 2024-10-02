add_library(trsp OBJECT
    edgeInfo.cpp
    pgr_trspHandler.cpp

    new_trsp.c
    trsp_driver.cpp

    trsp_withPoints.c
    trsp_withPoints_driver.cpp

    trspVia.c
    trspVia_driver.cpp

    trspVia_withPoints.c
    trspVia_withPoints_driver.cpp
    )
