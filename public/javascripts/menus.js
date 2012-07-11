/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function(){
    $('#books').sortable({
        axis: 'y',
        dropOnEmpty: false,
        handle: '.handle',
        cursor: 'crosshair',
        items: 'li',
        opacity: 0.4,
        scroll: true,
        update: function(){
            $.ajax({
                type: 'post',
                data: $('#books').sortable('serialize'),
                dataType: 'script',
                complete: function(request){
                    $('#books').effect('highlight');
                },
                url: '/books/sort'
            })
        }
    });
});