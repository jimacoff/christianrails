function move(story_id, button) {

  var target_node;

  if( current_node.linked_node ) {
    target_node = current_node['linked_node'];
  } else {
    // choose a direction based on moverule or button
    if(button === "L") {
      target_node = current_node['left_link'];
    } else if(button === "R") {
      target_node = current_node['right_link'];
    }
  }

  if(pop_item) {
    showItemViewer();
    pop_item = false;
  }

  request = void 0;
  request = $.ajax({
      type: 'GET',
      format: 'json',
      url: '/woods/stories/' + story_id + '/move_to.json?target_node=' + target_node
    });
  $('#choice-pane').addClass('hidden');
  //$('#processing').removeClass('hidden');

  request.done(function(data, textStatus, jqXHR) {
    current_node = data;
    if(current_node['item_found']) {
      item_gallery.push(current_node['item_found']);
      item_index = item_gallery.length - 1;
      pop_item = true;
    }
    drawNewNode();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured: " + textStatus);

    $('#choice-pane').removeClass('hidden');
  });
}

function drawNewNode() {

  // new text into panels
  $('#story-pane').html( current_node['node_text'] );
  $('#left-button').html( current_node['left_text'] );
  $('#right-button').html( current_node['right_text'] );

  // TODO paint the panels if necessary

  // show/hide buttons
  if( current_node['left_text'] !== '' ) {
    $('#left-button').removeClass('hidden');
    $('#right-button').removeClass('hidden');
    $('#big-button').addClass('hidden');
  } else {
    $('#left-button').addClass('hidden');
    $('#right-button').addClass('hidden');
    $('#big-button').removeClass('hidden');
  }
  $('#choice-pane').removeClass('hidden');

}

function showItemViewer() {
  showItem();

  $('#findpanel').removeClass('hidden');
  $('#nodepanel').addClass('hidden');
}

function hideItemViewer() {
  $('#findpanel').addClass('hidden');
  $('#nodepanel').removeClass('hidden');
}

function nextItem() {
  item_index += 1;
  if( item_index === item_gallery.length ) {
    item_index = 0;
  }
  showItem();
}

function prevItem() {
  item_index -= 1;
  if( item_index === -1 ) {
    item_index = item_gallery.length - 1;
  }
  showItem();
}

function showItem() {
  //current_node['item_found']['name']
  //current_node['item_found']['value']
  $('#item-image').html( item_gallery[item_index]['image'] );
  $('#item-desc').html(  item_gallery[item_index]['legend'] );
}
