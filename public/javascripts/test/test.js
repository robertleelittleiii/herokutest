/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function(){

        $("#alert").click(function() {
          alert(this.getAttribute("data-message"));
          return false;
        });
});