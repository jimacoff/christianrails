function moveToNewNode(destinationId) {
  cursor = destinationId;

  refreshNodeEditor();
  updateControls();
  updateMap();
}

function refreshNodeEditor() {
  currentNode = nodes[cursor - 1];

  $('#node-index-label').html('Node #' + currentNode['tree_index'] + ":");

  $('#node-name-box').val(currentNode['name']);
  $('#node-content-box').val(currentNode['node_text']);
  $('#left-text-box').val(currentNode['left_text']);
  $('#right-text-box').val(currentNode['right_text']);
}

function updateControls() {
  // TODO update button enableds
  $('#parent-button').prop('disabled', !canMoveToParent() );
  $('#left-button').prop('disabled', !canMoveLeft() );
  $('#right-button').prop('disabled', !canMoveRight() );
  $('#slide-left-button').prop('disabled', !canSlideLeft() );
  $('#slide-right-button').prop('disabled', !canSlideRight() );
}

function saveCurrentNode(currentNodeId) {
  // TODO ajax it
}

function updateMap() {

}


// movement

function moveToParent() {
  if( canMoveToParent() ) {
    moveToNewNode( Math.floor(cursor / 2) );
  }
}

function moveLeft() {
  if( canMoveLeft() ) {
    moveToNewNode(cursor * 2);
  }
}

function moveRight() {
  if( canMoveRight()) {
    moveToNewNode((cursor * 2) + 1);
  }
}

function slideLeft() {
  if( canSlideLeft() ) {
    moveToNewNode(cursor - 1);
  }
}

function slideRight() {
  if( canSlideRight() ) {
    moveToNewNode(cursor + 1);
  }
}

function canMoveToParent() {
  return cursor > 1;
}

function canMoveLeft() {
  return cursor * 2 <= max_node_index;
}

function canMoveRight() {
  return (cursor * 2) + 1 <= max_node_index;
}

function canSlideLeft() {
  return cursor > 1;
}

function canSlideRight() {
  return cursor < max_node_index;
}
