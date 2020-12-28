if (Boost_VERSION_MACRO >= 105400)
    ADD_LIBRARY(alpha_shape OBJECT
        pgr_alphaShape.cpp
        alphaShape.c
        alphaShape_driver.cpp
        )
else()
    ADD_LIBRARY(alpha_shape OBJECT
        alphaShape.c
        )
endif()
