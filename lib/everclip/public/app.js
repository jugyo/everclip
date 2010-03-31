$(function() {
  var currentIndex = 0;
  var scrollOffset = -100;
  var searchMode = false;

  var targetLi = function(index) {
    return $($('#clips li')[index]);
  };

  var toggleClip = function(index) {
    var target = targetLi(index);
    $('.text', target).toggle();
    $.scrollTo(target, {offset: {left: 0, top: scrollOffset}});
  };

  var toggleAllClips = function() {
    if ($('.text:hidden').length > 0) {
      openAllClips();
    } else {
      closeAllClips();
    }
    $.scrollTo(targetLi(currentIndex), {offset: {top: scrollOffset}});
  };

  var openAllClips = function() {
    $('.text:hidden').show();
  };

  var closeAllClips = function(index) {
    $('.text:visible').hide();
  };

  var moveTo = function(index) {
    if (index < 0 || index >= $('#clips li').length) {
      return;
    }

    var oldIndex = currentIndex;
    currentIndex = index;

    targetLi(oldIndex).removeClass('selected');

    var target = targetLi(currentIndex)
    target.addClass('selected');
    $.scrollTo(target, {offset: {top: scrollOffset}});
  };

  $('input#search').focus(function(){
    searchMode = true;
    $(this).select();
  });

  $('input#search').blur(function(){
    searchMode = false;
  });

  $(window).keydown(function(e){
    // console.log(e.keyCode);

    if (searchMode) {
      if (e.keyCode == 27) { // 'esc'
        $('input#search').blur();
        moveTo(currentIndex);
      }
    } else {
      if (e.keyCode == 74) { // 'j'
        moveTo(currentIndex + 1);
      }
      if (e.keyCode == 75) { // 'k'
        moveTo(currentIndex - 1);
      }

      if (e.keyCode == 191) { // '/'
        $('input#search').focus();
        e.preventDefault();
      }

      if (e.keyCode == 79) { // 'o'
        if (e.shiftKey) {
          toggleAllClips();
        } else {
          toggleClip(currentIndex);
        }
      }
    }
  });

  $('input#search').keydown(function(e) {
    // console.log(e.keyCode);
    if (e.keyCode == 13) {
      lastInputText = null;
    }
  });

  var lastInputText = null;
  var searching = false;
  $.timer(500, function (timer) {
    if (searching) {
      return;
    }

    var inputText = $('input#search').val();
    if (lastInputText == null || inputText != lastInputText) {
      setTimeout(function() {
        var newInputText = $('input#search').val();
        if (inputText == newInputText) {
          searching = true;
          $('#loading').show();
          $.get('/search', {q: inputText}, function(data) {
            $('#clips').html(data);
            $('#loading').hide();
            moveTo(0);
            searching = false;
          });
        }
      }, 100);
      lastInputText = inputText;
    }
  });

  moveTo(0);
});
