import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "channels"
import "chartkick/chart.js"
import $ from 'jquery';
global.$ = jQuery;
Rails.start()
Turbolinks.start()
//= require popper
//= require bootstrap-sprockets


//CUSTOM FUNCTIONS
// Download CSV
$(document).on('turbolinks:load', function() {
  function downloadCSV(csv, filename) {
    var csvFile;
    var downloadLink;

    // CSV file
    csvFile = new Blob([csv], {type: "text/csv"});

    // Download link
    downloadLink = document.createElement("a");

    // File name
    downloadLink.download = filename;

    // Create a link to the file
    downloadLink.href = window.URL.createObjectURL(csvFile);

    // Hide download link
    downloadLink.style.display = "none";

    // Add the link to DOM
    document.body.appendChild(downloadLink);

    // Click download link
    downloadLink.click();
  }

  function exportTableToCSV(filename) {
    var csv = [];
    var container = document.querySelector('#exchangeTable');
    var rows = container.querySelectorAll('table tr');
    
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll("td, th");
        for (var j = 0; j < cols.length; j++) 
            row.push(cols[j].innerText);
        
        csv.push(row.join(","));        
    }

    // Download CSV file
    downloadCSV(csv.join("\n"), filename);
}
    

if($("#exchangeTable").length){
      $( "#download" ).click(function() {
        exportTableToCSV('cryptoTable.csv');
      });
      //reload price usd
    setInterval(function(){
      reloadPrices() // this will run after every 4 seconds
  }, 4000);
    }
  });
  
  function reloadPrices() {
      Rails.ajax({
        url: "/prices",
        type: "get",
        success: function(data) {
          //nothing
          console.log("Success")
        },
        error: function(data) {
          console.log("error retrieving new ads rotation");
        }
      })
    }

   

    
