#!/bin/bash

sectionText "Disable matomo development mode"
./console development:disable &>> $BUILD_LOG
