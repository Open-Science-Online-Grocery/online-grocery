//= require active_admin/base

$(document).ready(function() {
  $('.add-note-link').on('click', function (e) {
    e.preventDefault();
    var apiTokenRequestId = $(this).data('api-token-request-id');

    // Create and show the modal
    var modal = $('<div id="note-modal" title="Add Note "></div>');
    modal.dialog({
      width: 700,
      modal: true,
      buttons: {
        'Reject / Revoke': function () {
          var noteText = $('#note-text').val();
          $.ajax({
            url: '/admin/api_token_requests/' + apiTokenRequestId + '/reject',
            method: 'PATCH',
            data: { admin_note: noteText },
            success: function () {
              modal.dialog('close');
              location.reload();
            },
          });
        },
        'Cancel': function () {
          modal.dialog('close');
        },
      },
      close: function () {
        modal.dialog('destroy');
        modal.remove();
      },
    });

    modal.html('<div style="padding:10px; text-align: center;"><textarea id="note-text" rows="6" cols="75" style="padding:10px; font-size: 14px;"></textarea></div>');
    var adminNote = $(this).data('admin-note');
    $('#note-text').val(adminNote);
  });
});
