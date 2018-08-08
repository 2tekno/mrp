function formSecurity(formName) {
    var formData = {'formName' : formName};
    $.ajax({
        type     : 'POST', 
        url      : '/form_security', 
        data     : formData, 
        dataType : 'json', 
        encode   : true
    }).done(function(data) {
            for(var obj in data) {
                if (data[obj].hasOwnProperty('FieldName')) {
                    var FieldName = data[obj]['FieldName'];

                    //console.log('FieldName == ' + FieldName);

                    var AccessLevel = data[obj]['AccessLevel'];
                    var myInputArr = document.getElementById(FieldName);
                    if (AccessLevel=='Read-Only') {
                        //console.log('xFieldName == ' + FieldName);
                        if (myInputArr) {
                            var typeElement = myInputArr.type;
                            //console.log('typeElement == ' + typeElement);

                            if (typeElement =='button') {
                                myInputArr.disabled = true;
                                
                            }
                            if (typeElement !='text') {
                                $(myInputArr).find("input,button,textarea,select").attr("disabled", "disabled");
                                $(myInputArr).attr("disabled", "disabled");
                                $(myInputArr).attr("readonly", "readonly");
                                if (typeElement == 'select-multiple')
                                    $(myInputArr).attr('disabled', true).trigger("chosen:updated");
                            }
                            else {
                                if (typeElement =='text') {
                                    $(myInputArr).attr("readonly", "readonly");
                                }
                                else {
                                    $(myInputArr).attr("readonly", "readonly");
                                }
                            }

                            var datepickers = document.getElementsByClassName("form-control hasDatepicker");
                            var valuesDT = Array.prototype.map.call(datepickers, function(el) {
                                $(el).datepicker( "option", "disabled", true );
                            });

                            var classes = document.getElementsByClassName("fa fa-trash");
                            var values = Array.prototype.map.call(classes, function(el) {
                                el.disabled = true;
                                el.style.cursor = 'default';
                                $(el).unbind('click');
                                $(el).removeClass('active');
                            });

                            var classes2 = document.getElementsByClassName("fa fa-pencil");
                            var values2 = Array.prototype.map.call(classes2, function(el) {
                                el.disabled = true;
                                el.style.cursor = 'default';
                                $(el).unbind('click');
                                $(el).removeClass('active');
                            });
                        }
                    }
                    if (AccessLevel=='Edit but No Delete') {
                        if (myInputArr) {
                            var typeElement = myInputArr.type;
                            if (myInputArr.classList.contains('fa-trash')) {
                                myInputArr.disabled = true;
                            }
                            if (FieldName == 'deleteRecord') {
                                var classes = document.getElementsByClassName("fa fa-trash");
                                var values = Array.prototype.map.call(classes, function(el) {
                                    el.disabled = true;
                                    el.style.cursor = 'default';
                                    $(el).unbind('click');
                                    $(el).removeClass('active');
                                });
                            }
                        }
                    }
                }
            }
    });
};

function FormValidation() {
    var IsValid = true;
    var fields = [
        document.getElementsByTagName("input"),
        document.getElementsByTagName("textarea"),
        document.getElementsByTagName("select")
    ];
    for (var a = fields.length, i = 0; i < a; i++) {
        for (var b = fields[i].length, j = 0; j < b; j++) {
            var field = (fields[i][j]);

            if (field.getAttribute("required") && (!field.value || field.value=='')) {
                field.setAttribute("aria-invalid", "true");
                IsValid = false;
            }						
            else if (field.getAttribute("aria-invalid")) {
                field.removeAttribute("aria-invalid");
            } 
                
        };
    }
    console.log('IsValid == ' + IsValid);
    return IsValid;
};

function goodbye(e){
  if (!e) e = windows.event;
  e.cancelBubble = true;
  e.returnValue = 'Are you sure you want to leave?';

  if (e.stopPropogation){
    e.stopPropogation();
    e.preventDefault();
  }
}

function addGroup(){
    window.location.href = '/groups/add';
}

function cancelEditGroup(){

 swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/groups';   });

}


function addProject(){
    window.location.href = '/projects/add';
}

function cancelAddSubProject(id){
console.log('cancelAddSubProject: ' + id);

    //window.location.href = '/projects';

     swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/projects/edit/'+id+ '/edit';   });

}

function cancelAddProject(){

    //window.location.href = '/projects';

     swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/projects';   });

}

function addContact(){

    window.location.href = '/contacts/add';
}

function addInstitution(){

    window.location.href = '/institutions/add';
}

function cancelEditProject(){

    //window.location.href = '/projects';

 swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/projects';   });

}

function cancelEditContact(){

    //window.location.href = '/contacts';
    swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/contacts';   });
}

function cancelAddContact(){

    //window.location.href = '/contacts';
      swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/contacts';   });
}

function cancelAddInstitution(){

    //window.location.href = '/institutions';

      swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/institutions';   });
}

function cancelEditInstitution(){

    //window.location.href = '/institutions';
    swal({ title: "You clicked on Cancel button",   
              text: "All changes on the current page will be lost!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Leave the current page.",   
              closeOnConfirm: false }, 
              function(){   window.location.href = '/institutions';   });
}




function getClientIp(req) {
  var ipAddress;
  // The request may be forwarded from local web server.
  var forwardedIpsStr = req.header('x-forwarded-for');
  if (forwardedIpsStr) {
    // 'x-forwarded-for' header may return multiple IP addresses in
    // the format: "client IP, proxy 1 IP, proxy 2 IP" so take the
    // the first one
    var forwardedIps = forwardedIpsStr.split(',');
    ipAddress = forwardedIps[0];
  }
  if (!ipAddress) {
    // If request was not forwarded
    ipAddress = req.connection.remoteAddress;
  }
  return ipAddress;
};
