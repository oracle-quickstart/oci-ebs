#Copyright © 2020, Oracle and/or its affiliates.

#The Universal Permissive License (UPL), Version 1.0


#/bin/bash

zipfile="ebusinesssuite.zip"

if [ -f $zipfile ]; then
    rm -f $zipfile
fi
zip -r  ebusinessuite.zip . -x  pack.sh .gitignore  terraform*  .terraform\* _docs\* orm\* .git\* .idea\* env-vars ebusinesssuite.zip *.zip README.md
