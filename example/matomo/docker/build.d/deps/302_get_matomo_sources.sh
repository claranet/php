#!/bin/bash

# docs: https://matomo.org/faq/how-to-install/faq_18271/

sectionText "Fetch matomo sources version $MATOMO_VERSION"
curl -L https://github.com/matomo-org/matomo/archive/$MATOMO_VERSION.tar.gz -o - | tar -zxf - --strip 1 &>> $BUILD_LOG
