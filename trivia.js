var data;

function loadJSON(callback) {

    var file = 'trivia.json';
    //var file = "file:///F:/Google Drive/Documents/Projects/trivia-questions/trivia.json"

    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', file, true);
    xobj.onreadystatechange = function() {
        if (xobj.readyState == 4 && xobj.status === 200) {
            // Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
            callback(xobj.responseText);
        }
    };
    xobj.send(null);
}

function init() {
    loadJSON(function(response) {
        // Parse JSON string into object
        data = JSON.parse(response);


        var selectCat = document.getElementById("categories");

        while (selectCat.firstChild) {
            selectCat.removeChild(selectCat.firstChild);
        }

        for (var cat in data) {
            var o = document.createElement("option");
            o.value = cat;
            o.text = cat;
            selectCat.appendChild(o);
        }

        selectCat.value = Object.keys(data)[Math.floor(Math.random() * Object.keys(data).length)];
        getQuestion();
    });
}


function getQuestion() {

    var selectCat = document.getElementById("categories");
    var category = selectCat.options[selectCat.selectedIndex].value;

    var questionAnswer = data[category][Math.floor(Math.random() * data[category].length)];

    document.getElementById("question").innerHTML = questionAnswer.Question;
    document.getElementById("answer").innerHTML = questionAnswer.Answer;
    document.getElementById("answer").className = "answer-out";
    document.getElementById("reveal").style.display = "block";

}


function revealAnswer() {
    document.getElementById("answer").className = "answer-in";
    document.getElementById("reveal").style.display = "none";
}

init();