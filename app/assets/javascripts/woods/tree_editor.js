function moveToNewNode(destinationId) {
  currentNode = nodes[cursor - 1];
  cursor = destinationId;

  if( nodeModified ) {
    saveCurrentNode( currentNode['id'] );
  } else {
    refreshEverything();
  }
}

function touchNode() {
  nodeModified = true;
}

function saveCurrentNode(currentNodeId) {

  if( $('#moverule-box').css('display') === "none" ) {
    var theMoverule = -1;
  } else {
    var theMoverule = $('#moverule-select').val();
  }

  request = void 0;
  request = $.ajax({
      type: 'PUT',
      format: 'json',
      url: '/woods/stories/' + storyId + '/storytrees/' + storytreeId + '/nodes/' + currentNodeId + '.json',
      data: {
        woods_node: {
          moverule_id: theMoverule,
          name: $('#node-name-box').val(),
          left_text:  $('#left-text-box').val(),
          right_text: $('#right-text-box').val(),
          node_text:  $('#node-content-box').val()
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    console.log("Saved the node!");

    updateNodeLocally(data);
    refreshEverything();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured: " + textStatus);
    // TODO pop an error flash or something
  });

}

function updateNodeLocally(callback_data) {
  var nodes_array_index = callback_data['tree_index'] - 1;

  nodes[ nodes_array_index ]['left_text'] = callback_data['left_text'];
  nodes[ nodes_array_index ]['right_text'] = callback_data['right_text'];
  nodes[ nodes_array_index ]['node_text'] = callback_data['node_text'];
  nodes[ nodes_array_index ]['name'] = callback_data['name'];
  nodes[ nodes_array_index ]['moverule_id'] = callback_data['moverule_id'];
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

  // moverule + accoutrements
  if(currentNode['moverule_id'] !== -1) {
    $('.moverule-option').each(function(rule) {
      if( currentNode['moverule_id'] === rule + 1) {
        $(this).prop('selected', 'selected');
      } else {
        $(this).prop('selected', '');
      }
    });
    $('#moverule-box').fadeIn();
  } else {
    $('#moverule-box').fadeOut();
  }

}

function updateControls() {
  $('#parent-button').prop('disabled', !canMoveToParent() );
  $('#left-button').prop('disabled', !canMoveLeft() );
  $('#right-button').prop('disabled', !canMoveRight() );
  $('#slide-left-button').prop('disabled', !canSlideLeft() );
  $('#slide-right-button').prop('disabled', !canSlideRight() );
}

function updateMap() {
  if(cursor > 1) {
    $('#parent-cell').html( nodes[Math.floor(cursor / 2) - 1]['name'] );
    $('#left-of-current-cell').html( nodes[cursor - 2]['name'] );

  } else {
    $('#parent-cell').html('---');
    $('#left-of-current-cell').html('---');
  }

  if(cursor < nodes.length) {
    $('#right-of-current-cell').html( nodes[cursor]['name'] );
  } else {
    $('#right-of-current-cell').html('---');
  }

  $('#current-cell').html(nodes[cursor - 1]['name']);

  if( cursor * 2 > nodes.length) {
    $('#l-cell').html('---');
    $('#r-cell').html('---');
  } else {
    $('#l-cell').html( nodes[(cursor * 2) - 1]['name'] );
    $('#r-cell').html( nodes[(cursor * 2)    ]['name'] );
  }

  if( cursor * 4 > nodes.length) {
    $('#ll-cell').html('---');
    $('#lr-cell').html('---');
    $('#rl-cell').html('---');
    $('#rr-cell').html('---');
  } else {
    $('#ll-cell').html( nodes[(cursor * 4) - 1]['name'] );
    $('#lr-cell').html( nodes[(cursor * 4)    ]['name'] );
    $('#rl-cell').html( nodes[(cursor * 4) + 1]['name'] );
    $('#rr-cell').html( nodes[(cursor * 4) + 2]['name'] );
  }

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
