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
