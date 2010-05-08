#!/bin/bash

# Path to Java executable.
JAVA=java

# Path to closure compiler jar file.
CLOSURE_JAR=compiler.jar

# Destination directory for compiled files.
DEST=compiled

# Files to compile for the bootstrap script, to be loaded in the parent frame.
BOOTSTRAP_PATHS="js/codemirror.js"

# Files to compile for the base script.
BASE_PATHS="js/editor.js js/select.js js/stringstream.js js/tokenize.js \
  js/undo.js js/util.js"

# Files to compile for the Javascript tokenizer.
JSPARSER_PATHS="js/tokenizejavascript.js js/parsejavascript.js"

# Prepends "--js " to each input filename
# and stores the resulting argument list in $JSFILE_ARGS.
jsargs() {
    JSFILE_ARGS=
    for JSFILE in $@; do
        JSFILE_ARGS+=" --js $JSFILE"
    done
}

mkdir -p $DEST

jsargs $BOOTSTRAP_PATHS
$JAVA -jar $CLOSURE_JAR $JSFILE_ARGS \
    --js_output_file=$DEST/codemirror_bootstrap.js \
    --compilation_level=SIMPLE_OPTIMIZATIONS

jsargs $BASE_PATHS
$JAVA -jar $CLOSURE_JAR $JSFILE_ARGS \
    --js_output_file=$DEST/codemirror_base.js \
    --compilation_level=SIMPLE_OPTIMIZATIONS

jsargs $JSPARSER_PATHS
$JAVA -jar $CLOSURE_JAR $JSFILE_ARGS \
    --js_output_file=$DEST/codemirror_js_parser.js \
    --compilation_level=SIMPLE_OPTIMIZATIONS
