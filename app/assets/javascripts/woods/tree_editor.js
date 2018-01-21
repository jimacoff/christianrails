function moveToNewNode(destinationId) {
  currentNode = nodes[cursor - 1];
  cursor = destinationId;

  if( anythingStillModified() ) {

    if( nodeModified ) {
      saveCurrentNode( currentNode['id'] );
    }
    if( treelinkModified || paintballModified || possibleitemModified || boxModified ) {
      saveAccoutrements( currentNode );
    }
  } else {
    refreshAllPanels();
  }
}

function saveNodeNow() {
  currentNode = nodes[cursor - 1];

  if( anythingStillModified() ) {
    if( nodeModified ) {
      saveCurrentNode( currentNode['id'] );
    }
    if( treelinkModified || paintballModified || possibleitemModified || boxModified ) {
      saveAccoutrements( currentNode );
    }
  }
}

function touchNode() {
  console.log('touched!');
  nodeModified = true;
}

function touchTreelink() {
  console.log('treelink touched!');
  treelinkModified = true;
}

function touchPaintball() {
  console.log('paintball touched!');
  paintballModified = true;
}

function touchPossibleitem() {
  console.log('possibleitem touched!');
  possibleitemModified = true;
}

function touchBox() {
  console.log('box touched!');
  boxModified = true;
}

function anythingStillModified() {
  return nodeModified || treelinkModified || paintballModified || possibleitemModified || boxModified;
}

function paletteCheck() {
  touchPaintball();
  colourThePalettePanel();
  if( $('#palette-checkbox').prop('checked') ) {
    $('#palette-chooser').hide();
  } else {
    $('#palette-chooser').show();
  }
}

function treelinkCheck() {
  touchTreelink();
  if( $('#treelink-checkbox').prop('checked') ) {
    $('#storytree-chooser').show();
  } else {
    $('#storytree-chooser').hide();
  }
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
    printSaveSuccess('node');
    updateNodeLocally(data);
    if( !anythingStillModified() ) { refreshAllPanels(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured: " + textStatus);
    printError(textStatus);
  });
}

function printSaveSuccess(obj) {
  $('#error-console').append('Saved ' + obj + '.\n');
  scrollToBottomOfLogBox();
}

function printError(err) {
  $('#error-console').append('ERROR SAVING NODE!\n');
  scrollToBottomOfLogBox();
}

function printUpdatedUpstream() {
  $('#error-console').append('Pushed node to live.\n');
  scrollToBottomOfLogBox();
}

function printErrorPushingLive(err) {
  $('#error-console').append('ERROR PUSHING LIVE!\n');
  scrollToBottomOfLogBox();
}

function printErrorPullingLive(err) {
  $('#error-console').append('ERROR PULLING LIVE NODE!\n');
  scrollToBottomOfLogBox();
}

function scrollToBottomOfLogBox() {
  $('#error-console').scrollTop($('#error-console')[0].scrollHeight);
}

//// WATERFALL MODE ///////

function toggleWaterfallMode() {
  if( waterfall ) {
    // hide waterfall panels + buttons
    $('.waterfall-panel').hide();
    $('#waterfall-controls').hide();

    $('#tree-map').fadeIn();

    $('#move-to-top-button').prop('disabled', false);

    $('#waterfall-toggler').val('Switch to Waterfall mode');
  } else {
    // show waterfall panels + buttons
    $('#tree-map').hide();

    $('.waterfall-panel').fadeIn();
    $('#waterfall-controls').css('display', 'inline-block');

    $('#move-to-top-button').prop('disabled', true);

    $('#waterfall-toggler').val('Switch to Classic mode');
  }
  waterfall = !waterfall;
}

// save current node and progress to left-most blank node
function saveAndMoveOn() {
  saveNodeNow();

  // if at bottom, navigate earliest blank node index
  if( isBottomLevel() ) {
    moveToNewNode( findEarliestBlankNode() );
  } else {
    if( leftNodeBlank() ) {
      moveLeft();
    } else if ( rightNodeBlank() ) {
      moveRight();
    } else {
      moveToNewNode( findEarliestBlankNode() );
    }
  }
}

// when finished a path in Waterfall, it sends you to the earliest blank node. or the top, if none.
// returns in tree index format, ie. 1-1023
function findEarliestBlankNode() {
  var inspecting = 0;
  while ( inspecting <= nodes.length ) {
    if (nodes[ inspecting ].node_text === "") {
      return inspecting + 1; // convert into tree index format
    }
    inspecting += 1;
  }
  return 1;
}

function leftNodeBlank() {
  var tracer = cursor * 2;
  if( nodes[tracer - 1].node_text === "" ) {
    return true;
  }
  return false;
}

function rightNodeBlank() {
  var tracer = (cursor * 2) + 1;
  if( nodes[tracer - 1].node_text === "" ) {
    return true;
  }
  return false;
}

// get the parent nodes & the relevant left/right choices
function updateWaterfallText() {
  var tracer = cursor;
  var newTracer;
  var backstory = [];
  var backstorySize = 2;

  for(var i = 0; i < backstorySize; i++) {
    newTracer = Math.floor(tracer / 2);
    if( newTracer > 0 ) {

      // determine if this was left or right node
      if ( tracer % 2 === 0 ) {
        backstory.unshift( nodes[newTracer - 1].left_text.toUpperCase() + "\n" );
      } else {
        backstory.unshift( nodes[newTracer - 1].right_text.toUpperCase() );
      }
      backstory.unshift( nodes[newTracer - 1].node_text );
      tracer = newTracer;
    }
  }

  // add a note about how close to bottom of tree you are & what you should be doing
  if( isAtEndingStructureRoot() ) {
    backstory.push("[You're at the root of an ending structure. Two more decisions.]");
  } else if( isTwoAwayFromBottom() ) {
    backstory.push("[Last decision before ending pause.]");
  } else if( isPenultimateLevel() ) {
    backstory.push("[Time to write an ending pause...]");
  } else if( isBottomLevel() ) {
    backstory.push("[Write the bottom of the tree.]");
  } else {
    backstory.push("[Level " + getLevel(cursor) + " of " + getLevel(nodes.length) + "]");
  }

  textBackstory = backstory.join('\n\n');

  if( textBackstory === "" ) {
    textBackstory = "First node of tree -- start writing!";
  }
  // display the backstory in the waterfall text panel
  $('.waterfall-text').text( textBackstory );
}

//// SAVERS //////

function saveAccoutrements( currentNode ) {
  if( treelinkModified ) {
    treelinkEnabled = $('#treelink-checkbox').prop('checked');
    saveTreelink(treelinkEnabled, currentNode['id'], $('#treelink-select').val());
  }

  if( paintballModified ) {
    paintballEnabled = !$('#palette-checkbox').prop('checked');
    savePaintball(paintballEnabled, currentNode['id'], $('#paintball-select').val());
  }

  if( possibleitemModified ) {
    possibleitemPerpetual = nodes[ Math.floor(currentNode['tree_index'] / 2) ]['moverule_id'] === 3;
    savePossibleitem(true, currentNode['id'], $('#possibleitem-select').val(), possibleitemPerpetual);
  }

  if( boxModified ) {
    saveBox(true, currentNode['id'], $('#box-select').val());
  }
}

function saveTreelink(setEnabled, nodeId, storytreeId) {

  request = void 0;
  request = $.ajax({
      type: 'POST',
      format: 'json',
      url: '/woods/treelinks/upsert.json',
      data: {
        woods_treelink: {
          node_id: nodeId,
          enabled: setEnabled,
          linked_tree_id: storytreeId
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    printSaveSuccess('treelink');
    updateTreelinkLocally(data);
    if( !anythingStillModified() ) { refreshAllPanels(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured saving treelink: " + textStatus);
    printError(textStatus);
  });
}

function savePaintball(setEnabled, nodeId, paletteId) {

  request = void 0;
  request = $.ajax({
      type: 'POST',
      format: 'json',
      url: '/woods/paintballs/upsert.json',
      data: {
        woods_paintball: {
          node_id: nodeId,
          enabled: setEnabled,
          palette_id: paletteId
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    printSaveSuccess('paintball');
    updatePaintballLocally(data);
    if( !anythingStillModified() ) { refreshAllPanels(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured saving paintball: " + textStatus);
    printError(textStatus);
  });
}
function savePossibleitem(setEnabled, nodeId, itemsetId, possibleitemPerpetual) {

  request = void 0;
  request = $.ajax({
      type: 'POST',
      format: 'json',
      url: '/woods/possibleitems/upsert.json',
      data: {
        woods_possibleitem: {
          perpetual: possibleitemPerpetual,
          node_id: nodeId,
          enabled: setEnabled,
          itemset_id: itemsetId
        }
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    printSaveSuccess('possibleitem');
    updatePossibleitemLocally(data);
    if( !anythingStillModified() ) { refreshAllPanels(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured saving possibleitem: " + textStatus);
    printError(textStatus);
  });
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
    printSaveSuccess('box');
    updateBoxLocally(data);
    if( !anythingStillModified() ) { refreshAllPanels(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured saving box: " + textStatus);
    printError(textStatus);
  });
}

////// Local updating //////

function updateNodeLocally(callback_data) {
  var nodes_array_index = callback_data['tree_index'] - 1;

  nodes[ nodes_array_index ]['left_text'] = callback_data['left_text'];
  nodes[ nodes_array_index ]['right_text'] = callback_data['right_text'];
  nodes[ nodes_array_index ]['node_text'] = callback_data['node_text'];
  nodes[ nodes_array_index ]['name'] = callback_data['name'];
  nodes[ nodes_array_index ]['moverule_id'] = callback_data['moverule_id'];
  nodeModified = false;
}

function updateTreelinkLocally(callback_data) {
  var theTreeIndex = callback_data['tree_index'];

  if(!treelinks[ theTreeIndex ]) {
    treelinks[ theTreeIndex ] = {};
  }
  treelinks[ theTreeIndex ]['linked_tree_id'] = callback_data['linked_tree_id'];
  treelinks[ theTreeIndex ]['enabled']        = callback_data['enabled'];
  treelinkModified = false;
}

function updatePaintballLocally(callback_data) {
  var theTreeIndex = callback_data['tree_index'];

  if(!paintballs[ theTreeIndex ]) {
    paintballs[ theTreeIndex ] = {};
  }
  paintballs[ theTreeIndex ]['palette_id'] = callback_data['palette_id'];
  paintballs[ theTreeIndex ]['enabled']    = callback_data['enabled'];
  paintballModified = false;
}

function updateBoxLocally(callback_data) {
  var theTreeIndex = callback_data['tree_index'];

  if(!boxes[ theTreeIndex ]) {
    boxes[ theTreeIndex ] = {};
  }
  boxes[ theTreeIndex ]['itemset_id'] = callback_data['itemset_id'];
  boxes[ theTreeIndex ]['enabled']    = callback_data['enabled'];
  boxModified = false;
}

function updatePossibleitemLocally(callback_data) {
  var theTreeIndex = callback_data['tree_index'];

  if(!possibleitems[ theTreeIndex ]) {
    possibleitems[ theTreeIndex ] = {};
  }
  possibleitems[ theTreeIndex ]['itemset_id'] = callback_data['itemset_id'];
  possibleitems[ theTreeIndex ]['enabled']    = callback_data['enabled'];
  possibleitemModified = false;
}

// SYNCING

// populates panel with node data but does not save yet
function pullDownNodeFromLive() {
  request = void 0;
  request = $.ajax({
      type: 'GET',
      format: 'json',
      url: 'https://www.christiandewolf.com/woods/sync/find_node_by_desc.json',
      data: {
        story_name: storyName,
        storytree_name: storytreeName,
        tree_index: currentNode['tree_index'],
        sync_token: $('#sync-token-field').val()
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    var oldName = $('#node-name-box').val();
    var oldText = $('#node-content-box').val();
    var oldLeft  = $('#left-text-box').val();
    var oldRight = $('#right-text-box').val();
    var oldRule  = $('#moverule-select').val();

    $('#node-name-box').val( data.node.name );
    $('#node-content-box').val( data.node.node_text );
    $('#left-text-box').val( data.node.left_text );
    $('#right-text-box').val( data.node.right_text );
    if(currentNode['moverule_id'] !== -1) {
      $('#moverule-select').val( data.node.moverule_id );
    }

    if(oldName !== $('#node-name-box').val() ||
       oldText !== $('#node-content-box').val() ||
       oldLeft !== $('#left-text-box').val() ||
       oldRight !== $('#right-text-box').val() ||
       oldRule !== $('#moverule-select').val()) { touchNode(); }
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured getting upstream node: " + textStatus);
    printErrorPullingLive(textStatus);
  });
}

function pushNodeToLive() {
  request = void 0;
  request = $.ajax({
      type: 'GET',
      format: 'json',
      url: 'https://www.christiandewolf.com/woods/sync/find_node_by_desc.json',
      data: {
        story_name: storyName,
        storytree_name: storytreeName,
        tree_index: currentNode['tree_index'],
        sync_token: $('#sync-token-field').val()
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    // get ids & update node upstream after confirmation
    pushCurrentNodeToLive(data.story_id, data.storytree_id, data.node.id);
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured getting upstream node: " + textStatus);
    printErrorPullingLive(textStatus);
  });

}

function pushCurrentNodeToLive(remoteStoryId, remoteStorytreeId, remoteNodeId) {
  if( $('#moverule-box').css('display') === "none" ) {
    var theMoverule = -1;
  } else {
    var theMoverule = $('#moverule-select').val();
  }

  request = void 0;
  request = $.ajax({
      type: 'PUT',
      format: 'json',
      url: 'https://www.christiandewolf.com/woods/stories/' + remoteStoryId + '/storytrees/' + remoteStorytreeId + '/nodes/' + remoteNodeId + '.json',
      data: {
        woods_node: {
          moverule_id: theMoverule,
          name: $('#node-name-box').val(),
          left_text:  $('#left-text-box').val(),
          right_text: $('#right-text-box').val(),
          node_text:  $('#node-content-box').val()
        },
        sync_token: $('#sync-token-field').val()
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    printUpdatedUpstream();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured pushing to upstream node: " + textStatus);
    printErrorPushingLive(textStatus);
  });
}

////////////

function refreshAllPanels() {
  refreshNodeEditor();
  updateControls();
  updateMap();
  updateWaterfallText();
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

  if( paintballs[cursor] && paintballs[cursor]['enabled'] ) {
    $('#paintball-select').val( paintballs[cursor]['palette_id'] )
    $('#palette-checkbox').prop('checked', false)
    $('#palette-chooser').show();
  } else {
    $('#palette-checkbox').prop('checked', true)
    $('#palette-chooser').hide();
  }

  if( isBottomLevel() ) {
    $('#treelink-box').show();

    if( treelinks[cursor] && treelinks[cursor]['enabled'] ) {
      $('#treelink-select').val( treelinks[ cursor ]['linked_tree_id'] )
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

function updateControls() {
  $('#parent-button').prop('disabled', !canMoveToParent() );
  $('#left-button').prop('disabled', !canMoveLeft() );
  $('#right-button').prop('disabled', !canMoveRight() );
  $('#slide-left-button').prop('disabled', !canSlideLeft() );
  $('#slide-right-button').prop('disabled', !canSlideRight() );

  countFilledNodes();
}

var dsh = '---';

function updateMap() {
  if(cursor > 1) {
    $('#parent-cell').html( nodes[Math.floor(cursor / 2) - 1]['name'] );
    $('#left-of-current-cell').html( nodes[cursor - 2]['name'] );

    if( isEvenNode() ){
      $('#left-parent-spacer').show();
      $('#right-parent-spacer').hide();
    } else {
      $('#left-parent-spacer').hide();
      $('#right-parent-spacer').show();
    }

  } else {
    $('#parent-cell').html(dsh);
    $('#left-of-current-cell').html(dsh);

    $('#left-parent-spacer').hide();
    $('#right-parent-spacer').hide();
  }

  if(cursor < nodes.length) {
    $('#right-of-current-cell').html( nodes[cursor]['name'] );
  } else {
    $('#right-of-current-cell').html(dsh);
  }

  $('#current-cell').html(nodes[cursor - 1]['name']);

  if( cursor * 2 > nodes.length) {
    $('#l-cell').html(dsh);
    $('#r-cell').html(dsh);
  } else {
    $('#l-cell').html( nodes[(cursor * 2) - 1]['name'] );
    $('#r-cell').html( nodes[(cursor * 2)    ]['name'] );
  }

  if( cursor * 4 > nodes.length) {
    $('#ll-cell').html(dsh);
    $('#lr-cell').html(dsh);
    $('#rl-cell').html(dsh);
    $('#rr-cell').html(dsh);
  } else {
    $('#ll-cell').html( nodes[(cursor * 4) - 1]['name'] );
    $('#lr-cell').html( nodes[(cursor * 4)    ]['name'] );
    $('#rl-cell').html( nodes[(cursor * 4) + 1]['name'] );
    $('#rr-cell').html( nodes[(cursor * 4) + 2]['name'] );
  }

  advancedColourMap();
}

function advancedColourMap() {
  $('.map-cell-text').each(function() {
    if($( this ).text() === dsh ) {
      $( this ).parent().css('opacity', 0.25);
    } else {
      $( this ).parent().css('opacity', 1);
    }
  });

  if(cursor < nodes.length) {
    if( getLevel( nodes[cursor-1]['tree_index'] ) !== getLevel( nodes[cursor]['tree_index'] ) ) {
      $('#right-of-current-cell').parent().css('opacity', 0.25);
    } else {
      $('#right-of-current-cell').parent().css('opacity', 1);
    }
  }

  if(cursor > 1) {
    if( getLevel( nodes[cursor-1]['tree_index'] ) !== getLevel( nodes[cursor-2]['tree_index'] ) ) {
      $('#left-of-current-cell').parent().css('opacity', 0.25);
    } else {
      $('#left-of-current-cell').parent().css('opacity', 1);
    }
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
  if( cursor > 1 ) {
    return nodes[ Math.floor(cursor / 2) - 1 ]['moverule_id'];
  } else {
    return -1;
  }
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
  refreshAllPanels();
  setWholeNodeAsUnmodified();
}

function moveToTop() {
  moveToNewNode(1);
}

function setWholeNodeAsUnmodified() {
  nodeModified = false;
  treelinkModified = false;
  paintballModified = false;
  possibleitemModified = false;
  boxModified = false;
}

function countFilledNodes() {
  filled = 0;
  for (var i = 0; i < nodes.length; i++) {
    if( nodes[i]['name'] !== '' ) {
      filled += 1;
    }
  }
  $('#filled-nodes-counter').html( filled + '/' + nodes.length + ' filled');
  $('#filled-percentage').html( ( filled / nodes.length * 100 ).toFixed(1) + '% complete');
}

function isAtEndingStructureRoot() {
  return (cursor * 16 > nodes.length) && !isTwoAwayFromBottom() && !isPenultimateLevel() && !isBottomLevel();
}

function isTwoAwayFromBottom() {
  return (cursor * 8 > nodes.length) && !isPenultimateLevel() && !isBottomLevel();
}

function isPenultimateLevel() {
  return (cursor * 4 > nodes.length) && !isBottomLevel();
}

function isBottomLevel() {
  return (cursor * 2 > nodes.length);
}

function getLevel(treeIndex) {
  var lCount = 1;
  if(treeIndex === 1) { return 1; }
  while((treeIndex + 1) > 2**lCount) {
    lCount += 1;
  }
  return lCount;
}

// colouring

function colourThePalettePanel() {
  var currentPalette;

  if( $('#palette-checkbox').prop('checked') ) {
    // inherit from parent
    if(cursor > 1) {
      var lookingAt = Math.floor(cursor / 2);
      while( !paintballs[lookingAt] && lookingAt > 1 ) {
        lookingAt = Math.floor(lookingAt / 2);
      }
      if( paintballs[lookingAt] ) {
        currentPalette = palettes[ paintballs[lookingAt]['palette_id'] ];
      }
    }
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
