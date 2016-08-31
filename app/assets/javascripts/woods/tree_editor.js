function moveToNewNode(destinationId) {
  cursor = destinationId;

  if( nodeModified ) {
    console.log('needs a save!');
  } else {
    refreshEverything();
  }

}

function saveCurrentNode(currentNodeId) {

  request = void 0;
  request = $.ajax({
      type: 'POST',
      format: 'json',
      url: '/woods/stories/' + storyId + '/storytrees/' + storytreeId + '/nodes/' + currentNodeId + '.json',
      data: {
        woods_node: {
          //moverule_id: ,
          name: $('#node-name-box').val(),
          left_text:  $('#left-text-box').val(),
          right_text: $('#right-text-box').val(),
          node_text:  $('#node-content-box').val()
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    console.log("Saved the node!");
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured: " + textStatus);
    // TODO pop an error flash or something
  });

}

function refreshEverything() {
  nodeModified = false;

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

function updateMap() {
  // TODO
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
