function moveToNewNode(destinationId) {
  currentNode = nodes[cursor - 1];
  cursor = destinationId;

  if( nodeModified ) {
    saveCurrentNode( currentNode['id'] );
    saveAccoutrements( currentNode );
  } else {
    refreshEverything();
  }
}

function touchNode() {
  console.log('touched!');
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

function saveAccoutrements( currentNode ) {
  // TODO
  //saveTreelink();

  //savePaintball();

  //savePossibleItem();

  if( boxes[currentNode['tree_index']] ) {
    saveBox(true, currentNode['id'], $('#box-select').val());
  }
}

function saveBox(setEnabled, nodeId, itemsetId) {

  request = void 0;
  request = $.ajax({
      type: 'POST',
      format: 'json',
      url: '/woods/boxes/upsert.json',
      data: {
        woods_box: {
          node_id: nodeId,
          enabled: setEnabled,
          itemset_id: itemsetId
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    console.log("Saved the box!");
    updateBoxLocally(data);
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured saving box: " + textStatus);
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

function updateBoxLocally(callback_data) {
  var theTreeIndex = callback_data['tree_index'];

  boxes[ theTreeIndex ]['itemset_id'] = callback_data['itemset_id'];
  boxes[ theTreeIndex ]['enabled']    = callback_data['enabled'];
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

  if( isPenultimateLevel() || isBottomLevel() ) {
    $('#left-text-box').prop('disabled', true);
    $('#right-text-box').prop('disabled', true);
  } else {
    $('#left-text-box').prop('disabled', false);
    $('#right-text-box').prop('disabled', false);
  }

  // moverule + accoutrements
  if(currentNode['moverule_id'] !== -1) {
    $('#moverule-select').val( currentNode['moverule_id'] )
    $('#moverule-box').show();
  } else {
    $('#moverule-box').hide();
  }

  if( paintballs[cursor] ) {
    $('#paintball-select').val( paintballs[cursor]['palette_id'] )
    $('#palette-checkbox').prop('checked', false)
    $('#palette-chooser').show();
  } else {
    $('#palette-checkbox').prop('checked', true)
    $('#palette-chooser').hide();
  }

  if( isBottomLevel() ) {
    $('#treelink-box').show();

    if( treelinks[currentNode['tree_index']] ) {
      $('#treelink-select').val( treelinks[ currentNode['tree_index'] ]['linked_tree']['id'] )
      $('#treelink-checkbox').prop('checked', true)
      $('#storytree-chooser').show();
    } else {
      $('#treelink-checkbox').prop('checked', false)
      $('#storytree-chooser').hide();
    }

    if( isNodeWithABox() ){
      if( boxes[cursor] ) {
        $('#box-select').val( boxes[cursor]['itemset_id'] )
      }
      $('#box-box').show();
    } else {
      $('#box-box').hide();
    }

    if( isNodeWithAnItem() ) {
      if( possibleitems[cursor] ) {
        $('#possibleitem-select').val( possibleitems[cursor]['itemset_id'] )
      }
      $('#possibleitem-box').show();
    } else {
      $('#possibleitem-box').hide();
    }


  } else { // not bottom level
    $('#treelink-box').hide();
    $('#possibleitem-box').hide();
    $('#box-box').hide();
  }

  colourThePalettePanel();
}

function paletteCheck() {
  touchNode();
  colourThePalettePanel();
  if( $('#palette-checkbox').prop('checked') ) {
    $('#palette-chooser').hide();
  } else {
    $('#palette-chooser').show();
  }
}

function treelinkCheck() {
  touchNode();
  if( $('#treelink-checkbox').prop('checked') ) {
    $('#storytree-chooser').show();
  } else {
    $('#storytree-chooser').hide();
  }
}

function isPenultimateLevel() {
  return (cursor * 4 > nodes.length) && !isBottomLevel();
}

function isBottomLevel() {
  return (cursor * 2 > nodes.length);
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

function isNodeWithABox() {
  return (parentNodeMoverule() === 5 || parentNodeMoverule() === 6) && isEvenNode();
}

function isNodeWithAnItem() {
  return (parentNodeMoverule() === 3 || parentNodeMoverule() === 4) && isEvenNode();
}

function parentNodeMoverule() {
  return nodes[ Math.floor(cursor / 2) - 1 ]['moverule_id'];
}

function isEvenNode() {
  return (cursor % 2 === 0)
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

function revertChanges() {
  refreshEverything();
  nodeModified = false;
}

function moveToTop() {
  moveToNewNode(1);
}

function colourThePalettePanel() {

  if( $('#palette-checkbox').prop('checked') ) {
    // inherit from parent
    var lookingAt = Math.floor(cursor / 2);
    while( !paintballs[lookingAt] && lookingAt !== 1 ) {
      lookingAt = Math.floor(lookingAt / 2);
    }
    currentPalette = palettes[ paintballs[lookingAt]['palette_id'] ];
  } else {
    currentPalette = palettes[ $('#paintball-select').val() ];
  }

  if(currentPalette) {
    var fore = '#' + currentPalette['fore_colour'],
        back = '#' + currentPalette['back_colour'],
        alt  = '#' + currentPalette['alt_colour'];

    $('#paintball-box').css('color', fore);
    $('#paintball-box').css("background-image", "-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, " + back + "), color-stop(100%, " + alt + "))");
    $('#paintball-box').css("background-image", "-webkit-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
    $('#paintball-box').css("background-image", "-moz-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
    $('#paintball-box').css("background-image", "-o-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
    $('#paintball-box').css("background-image", "linear-gradient(top, " + back + " 0%," + alt + " 100%)");
  }
}
