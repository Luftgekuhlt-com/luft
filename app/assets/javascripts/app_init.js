(function($){
    $(document).ready(function(){

        $('.form-group.required').each(function(ind, el){
            $('input, textarea', $(el)).on('blur', function(){
                var fld = this;
                window.setTimeout(function(){
                    var val = $(fld).val();
                    if(val == undefined || val.length == 0){
                        $(el).addClass('missing-required');
                    }else{
                        $(el).removeClass('missing-required');
                    }
                }, 500);
            });
        });

        $('a.dropdown').on('click', function(){
            var href = $(this).attr('href');
            if(href && href.length > 0){
                window.location = href;
            }
        });

        $('body').on('keyup', 'input.float', function(e){
          var val = $(this).val();
          if(isNaN(val)){
            if(!isNaN(parseFloat(val))){
              $(this).val(parseFloat(val));
            }else{
              if(val != '-' && val != '.') $(this).val('');
            }
          }
          return true;
        });
    window.initTooltips = function(sel){
      $('.bs-tip', $(sel)).tooltip({
        container: 'body',
        template: '<div class="tooltip bs-tip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
      });
      $('.bs-tip-new', $(sel)).each(function(ind, el){
        var ctr = $(el).data('container') || 'body';
        var placement = $(el).data('placement') || 'top';
        var tipClass = $(el).data('tipclass') || '';
        $(el).tooltip({
        container: ctr,
        placement: placement,
        trigger: "hover",
        html: true,
        template: '<div class="tooltip bs-tip '+tipClass+'" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
      });
      });

    }

    window.initTooltips('body');


    //update tabindexes
    $('[tabindex]', $('.main-content')).removeAttr('tabindex');
    var tabind = 0;
    $(':input', $('.main-content')).each(function(ind, el) {
        if ($(el).attr('type') != 'hidden') {
            $(el).attr('tabindex', (tabind += 1));
        }
    });

    window.initRemoteModals = function(sel){
      $('a.modal-remote', $(sel)).each(function(ind, el){
        var key = $(el).data('key');
        var url = $(el).data('url');
        if(url == undefined || url.length == 0){
          url = $(el).attr('href');
          $(el).data('url', url);
          $(el).attr('href', 'javascript:;')
        }
        if($('#'+key).length == 0){
          $('body').append('<div id="'+key+'"/>');
        }
        $(el).off('click');
        $(el).on('click', function(e){
          $('#'+key).load(url,null,function(data){
            //window.initPage('#'+key);
            if(data.length > 0){
              $('.tabs', '#'+key).tabs();
              $('.dropdown-trigger', '#'+key).dropdown();
              $('select[multiple="multiple"] option[value=""]', '#'+key).attr('disabled', true);
              $('select', '#'+key).formSelect();
              $('input[type=checkbox]', '#'+key).addClass('filled-in');
              $('.fixed-action-btn', '#'+key).floatingActionButton();
              $('#'+key+' .modal').modal();
              $('#'+key+' .modal').modal('open');
              $('input.datepicker, input.date', '#'+key).datepicker({
                autoClose: true,
                format: 'yyyy-mm-dd',
                formatSubmit: 'yyyy-mm-dd'
              });
              M.updateTextFields();

              tinymce.init({
                selector: '.html-editor textarea',
                body_class: 'tiny_editor',
                plugins: 'advlist code lists link paste preview table visualblocks',
                min_height: 400,
                toolbar: "undo redo | cut copy paste | alignleft aligncenter alignright | bold italic underline | bullist numlist table | link unlink | formatselect fontselect forecolor | code",
                menubar: "edit insert view format table",
                content_css: [window.appCss, "https://fonts.googleapis.com/css?family=Montserrat:400,400i,700,700i&display=swap"],
                visualblocks_default_state: true
              });
            }
          });
          e.preventDefault();
          return false;
        });
      });
    }

    window.initRemoteModals('body')
    $('body').on('hidden.bs.modal', function(e){
     $('.modal-backdrop').remove();
    });

    // maxlength textarea with countdown
     $("textarea[maxlength]").each(function() {
        var $field = $(this);
        $field.parent().append("<div class=\"charsleft\"><span>" + $field.attr("maxlength") + "</span> "+window.charsRemainingText+".</div>");
        $field.keyup(function() {
          var l = $field.val().length;
          var maxl = parseInt($field.attr("maxlength"));
          if (!isNaN(maxl) && (l <= maxl)) {
              $field.parent().find(".charsleft").html("<span>" + (maxl - l) + "</span> "+window.charsRemainingText+".");
          } else {
              $field.parent().find(".charsleft").html("<span>0</span> "+window.charsRemainingText+".");
              var shortVal = $field.val().substring(0, maxl);
              $field.val(shortVal);
          }
        });
        $field.keyup();
    });

    $('input[type=hidden].fh-date-picker').each(function(ind, el){
      $(el).after('<div class="input-group date"/>');
      var inputWrap = $(el).next('.input-group.date');
      $(inputWrap).append('<input type="text" class="form-control" />');
      $(inputWrap).append('<span class="input-group-addon"><span class="glyphicon-calendar glyphicon"></span></span>');
      $(el).closest('.form-group.hidden').removeClass("hidden");
      var val = $(el).val();
      var initialDate = val.length > 0 ? moment(val) : moment();
      if(initialDate.isValid()){
        $(inputWrap).find('input').val(initialDate.format('MM/DD/YYYY'));
      }
      $(inputWrap).datetimepicker({
        defaultDate: initialDate,
        allowInputToggle: true
      }).on('dp.change', function(e){
        $(el).val(e.date.format('YYYY-MM-DD'));
        $(el).trigger('change');
      });
    });

    $('input[type=file]').each(function(ind, el) {
            var inputContainer = $(el).data('image-input');

            // if there is a preview selector,
            if (inputContainer && inputContainer.length > 0) {
                $(el).on("change", function(e) {
                    var file = e.currentTarget.files[0];
                    var reader = new FileReader();

                    // the user just uploaded a new image, so
                    // if there is a removal field, update its
                    // value to 0 to reset old removal actions...
                    $("#remove_image", inputContainer).val("0");

                    reader.onload = function(event) {
                        $(".btn-upload-image", inputContainer).text("Replace");
                        $("img", inputContainer).prop("src", event.target.result);
                        $("img", inputContainer).removeClass("default");
                        $("img", inputContainer).removeClass("hidden");
                        $(".modal", inputContainer).modal("hide");
                        $(".image-remove", inputContainer).show();
                        $(".image-revert", inputContainer).show();
                    }

                    reader.readAsDataURL(file);
                });

                $(".btn-revert-image", inputContainer).on("click", function() {
                    var defaultSrc = $(this).data("default-src");

                    $.rails.confirm("Are you sure you want to revert to the default image?", function() {
                        var fileInput = $("input[type=file]", inputContainer);

                        // reset the file input...
                        fileInput.wrap("<form>").closest("form").get(0).reset();
                        fileInput.unwrap();

                        $("#remove_image", inputContainer).val("1");
                        $("img", inputContainer).prop("src", defaultSrc);
                        $("img", inputContainer).addClass("default");
                        $(".image-revert", inputContainer).hide();
                    }, function() {});
                });

                $(".btn-remove-image", inputContainer).on("click", function() {

                    $.rails.confirm("Are you sure you want to remove the image?", function() {
                        var fileInput = $("input[type=file]", inputContainer);

                        // reset the file input...
                        fileInput.wrap("<form>").closest("form").get(0).reset();
                        fileInput.unwrap();

                        $("#remove_image", inputContainer).val("1");
                        $("img", inputContainer).addClass("hidden");
                        $("img", inputContainer).prop("src", "");
                        $(".btn-upload-image", inputContainer).text("Add");
                        $(".image-remove", inputContainer).hide();
                    }, function() {});
                });
            }
        });

    $('.focus-tip').each(function(ind, el){
        var tip = $(el).data('tip');
        if(tip && tip.length > 0){
          var grouped = $(el).data('grouped') == 'true';
          var trigger = grouped ? 'manual' : 'focus';
          $(el).data('cancelBlur', false);
          var options = {};
          options['placement'] = $(el).data('placement') || 'right';
          options['trigger'] = $(el).data('trigger') || trigger;
          options['title'] = tip;
          options['template'] = '<div class="tooltip bs-tip info-tip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>';

          $(el).tooltip(options);

          if (grouped)
          {
            // the 'cancelBlur' variable helps to keep
            // a quick blur-focus (as you get from tabbing inputs)
            // from racing and causing funkiness...
            $(el).find("*").on('focus', function() {
              $(el).data('cancelBlur', true);
              $(el).tooltip('show');
            });

            $(el).find("*").on('blur', function() {
              $(el).data('cancelBlur', false);
              window.setTimeout(function() {
                if ($(el).data('cancelBlur') != true )
                  $(el).tooltip('hide');
              }, 100);
            });
          }
        }
    });
    $(window).on('load resize', function() {
     $('.row.equalize-grid-items').each(function(ind, row){
      var h = 0;
      $('>div', row).css({height: 'auto'});
      $('>div', row).each(function(ind2, item){
       //console.log('item'+ind2, $(item).height());
       h = Math.max(h, $(item).height());
      });
      //console.log('maxheight', h)
      $('>div', row).height(h);
     });
    });
    $(window).on('load resize', function() {
      if(!window.sizingContentStrips){
        window.sizingContentStrips = true;
        $('.content-strip-wrap').each(function(ind, ctr){
          var targetDisplay = parseInt($(ctr).data('target-display'));
          if(isNaN(targetDisplay) || targetDisplay <= 0) targetDisplay = 350;
          var displayCount = Math.floor($(ctr).width() / targetDisplay);
          //console.log('content-strip-1', $(ctr).width() / displayCount, $(ctr).width() , displayCount);
          $('.content-item', $(ctr)).width(($(ctr).width() - ((displayCount -1) * 30)) / displayCount);
          $('.video-item').width(($(ctr).width() - ((displayCount -1) * 30)) / displayCount);
          var h = 0;
          $('.content-item', $(ctr)).each(function(i, c){
            if($(c).height() > h){
              h = $(c).height();
            }
          });
          $(ctr).height(h);
          $('.content-strip', $(ctr)).height(h);
          var ih = 0;
          $('.content-item img', $(ctr)).each(function(i, c){
            if($(c).height() > ih){
              ih = $(c).height();
            }
          });
          $('.content-strip-left, .content-strip-right').css({height: ih, lineHeight: ih+'px'});
          var il = $('.content-items', $(ctr)).position().left;
          var w = $('.content-items', $(ctr)).width();
          var itemCount = $('.content-item', $(ctr)).length
          var itemWidth = $('.content-item', $(ctr)).first().outerWidth(true);
          var gutter = 30; //itemWidth - $('.content-item', $(ctr)).first().outerWidth();
          var aw = $(ctr).width();
          var pageSize = displayCount;//Math.floor(aw / itemWidth);
          //var pageSize = ($(ctr).width() - ((displayCount -1) * 30));
          var pages = Math.ceil(itemCount / pageSize);
          var lastPageSize = itemCount % pageSize;
          console.log('content-strip-lastPageSize', lastPageSize, itemCount, pageSize);
          var pageWidth = pageSize * itemWidth;
          console.log('content-strip-setup', il, w, itemWidth, aw, pageSize, pages, pageWidth, lastPageSize);
          if( w - aw < 50){
            $('.content-strip-left', $(ctr)).addClass('disabled');
            $('.content-strip-right', $(ctr)).addClass('disabled');
          }
          if(il >= 0){
            $('.content-strip-left', $(ctr)).addClass('disabled');
          }else{
            $('.content-strip-left', $(ctr)).removeClass('disabled');
          }
          $('.content-strip-right', $(ctr)).off('click');
          $('.content-strip-right', $(ctr)).on('click', function(){
            if($(this).hasClass('disabled')){
              console.log('right disabled');
              return false;
            }
            var l = $('.content-items', $(ctr)).position().left;
            var maxLeft = (-1 * (w - aw));
            console.log('content-strip-maxLeft', maxLeft);
            var newLeft = l - pageWidth;
            console.log('content-strip-newLeft', newLeft, l, pageWidth, (l-pageWidth));
            if(newLeft < maxLeft){
              newLeft = l - (lastPageSize * itemWidth);
              console.log('before-right-last', newLeft, pageSize, lastPageSize, itemWidth);
            }
            console.log('before-right', l, w, aw, maxLeft, newLeft, pageWidth);

            $('.content-items', $(ctr)).animate({left:  newLeft}, 1000, function(){
              var al = $('.content-items', $(ctr)).position().left;
              console.log('after-right', al, maxLeft)
              if(al <= maxLeft){
                $('.content-strip-right', $(ctr)).addClass('disabled');
              }else{
                $('.content-strip-right', $(ctr)).removeClass('disabled');
              }
              if(al >= 0){
                $('.content-strip-left', $(ctr)).addClass('disabled');
              }else{
                $('.content-strip-left', $(ctr)).removeClass('disabled');
              }
            });

          });
          $('.content-strip-left', $(ctr)).off('click');
          $('.content-strip-left', $(ctr)).on('click', function(){
            if($(this).hasClass('disabled')){
              console.log('left disabled');
              return false;
            }
            var l = $('.content-items', $(ctr)).position().left;
            var w = $('.content-items', $(ctr)).width();
            var aw = $(ctr).width();
            var newLeft = l + pageWidth;
            if(newLeft > 0){
              newLeft = 0;
            }

            $('.content-items', $(ctr)).animate({left:  newLeft}, 1000, function(){
              var al = $('.content-items', $(ctr)).position().left;
              console.log('after-left', al)
              if(al >= 0){
                $('.content-strip-left', $(ctr)).addClass('disabled');
              }else{
                $('.content-strip-left', $(ctr)).removeClass('disabled');
              }
              $('.content-strip-right', $(ctr)).removeClass('disabled');
            });

          });
        });
        window.sizingContentStrips = false;
      }
    });


    $('body').on('slide-preview-init', '.slide-preview', function(e){
     //console.log('slide-preview-init', this, e)
     var el = this;
     var w = $(el).width();
     var ratio = w / 2000;
     var h = 980 * ratio;
     $(el).height(h);
     var iframe = $(el).find('iframe');
     //console.log('iframe-el', w, ratio);
     $(iframe).on('load', function(e){
      //console.log('iframe-load', w, ratio);
      $(iframe).contents().find('body').css('transform', 'scale('+ratio+')');
      $(iframe).contents().find('body').css('transform-origin', '0 0');
      var vid = $(iframe).contents().find('video');
      if(vid){
       var vh = $(vid).height();
       var offset = (-1 * (vh / 2)) * (1 + ratio);
       console.log('iframe-vid', vh, offset, vid)
       $(vid).css({top: '50%', marginTop: offset});
      }
     });
    });
    $('.slide-preview').trigger('slide-preview-init');



    function createCookie(name, value, days) {
        var expires;

        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
    }


/*
$.rails.allowAction = function(element) {
    var $link, $modal_html, message, modal_html;
    message = element.data('confirm');
    title = element.data('title') || "Please Confirm";
    if (!message) {
      return true;
    }
    $link = element.clone().removeAttr('class').removeAttr('data-confirm').addClass('btn').addClass('btn-danger').html("Yes, I'm sure");
    modal_html = "<div id=\"confirm_modal\" class=\"modal fade confirm-modal\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-header\"><button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\">"+title+"</h4></div><div class=\"modal-body\">" + message + "</div><div class=\"modal-footer\"><a data-dismiss=\"modal\" class=\"btn\">Cancel</a></div></div></div></div>";
    $modal_html = $(modal_html);
    $modal_html.find('.modal-footer').append($link);
    $modal_html.modal();
    $link.on('click', function(){
      $modal_html.modal('hide');
    });
    return false;
  };

$.rails.confirm = function(message, cbYes, cbNo, title) {
    var $modal_html, modal_html;
    title = title || "Please Confirm";
    if (!message) {
      return true;
    }
    modal_html = "<div id=\"confirm_modal\" class=\"modal fade confirm-modal\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-header\"><button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\">"+title+"</h4></div><div class=\"modal-body\">" + message + "</div><div class=\"modal-footer\"><a data-dismiss=\"modal\" class=\"btn btn-default btn-cancel\">Cancel</a><a href=\"javascript:;\" class=\"btn btn-primary\">Yes</a></div></div></div></div>";
    $modal_html = $(modal_html);
    $modal_html.modal();
    $('.modal-footer .btn-primary', $modal_html).on('click', function(){
      cbYes();
      $modal_html.modal('hide');
    });
    $('.modal-footer .btn-cancel', $modal_html).on('click', function(){
      cbNo();
    });
    $('.modal-header .close', $modal_html).on('click', function(){
      cbNo();
    });
    return false;
  };

  var alertModalHTML = '<div id="alert_modal" class="modal fade alert-modal"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"></div><div class="modal-body"><p class="message"></p></div><div class="modal-footer"><a data-dismiss="modal" class="btn btn-default">OK</a></div></div></div></div>';

  $.rails.alert = function(message, title, hideOk) {
    var $modal = $(alertModalHTML);
    if(title && title.length > 0){
      $modal.find(".modal-header").append('<h4 class="modal-title">'+title+'</h4>');
    }
    $modal.find(".message").html(message);
    if(hideOk === true){
      $modal.find(".modal-footer").hide();
    }
    $modal.modal();
  }

  $.rails.alert2 = function(message, title, cb) {
    var $modal = $(alertModalHTML);
    if(title && title.length > 0){
      $modal.find(".modal-header").append('<h4 class="modal-title">'+title+'</h4>');
    }
    $modal.find(".message").html(message);
    if(cb){
      $modal.find(".modal-footer .btn-default").on('click', function(){
        cb();
      });
    }
    $modal.modal();
  }

  $.rails.flash = function(message, level){
    if($('#flash').length == 0){
      $('.section-nav').after('<div id="flash"></div>');
      $('.view-body').prepend('<div id="flash"></div>');
    }
    var levelClass = "info";
    if(level && (level == 'error' || level == 'alert')){
      levelClass = 'danger';
    }
    if(level && (level == 'notice' || level == 'success')){
      levelClass = 'success';
    }
    var flashMessage = $('<div class="alert alert-'+levelClass+'" role="alert">'+message+'</div>');
    $('#flash').append(flashMessage);
    window.setTimeout(function(){
      $(flashMessage).fadeOut(function(){$(flashMessage).remove();});
    }, 5000);
  } */
    });
})(jQuery);