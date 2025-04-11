<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Text Processor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            padding: 40px;
        }
        .container {
            background: #fff;
            padding: 25px 30px;
            max-width: 600px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }
        input[type="file"],
        textarea,
        input[type="submit"] {
            width: 100%;
            margin-top: 8px;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        input[type="submit"] {
            background-color: #3498db;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #2980b9;
        }
        .result {
            margin-top: 30px;
            padding: 15px;
            background-color: #eafaf1;
            border-left: 5px solid #2ecc71;
        }
        .error {
            margin-top: 30px;
            padding: 15px;
            background-color: #fdecea;
            border-left: 5px solid #e74c3c;
            color: #c0392b;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Enter your input (choose one):</h2>

    <form action="/processInput" method="post" enctype="multipart/form-data">
        <label for="fileInput">Upload a .txt File:</label>
        <input type="file" id="fileInput" name="fileInput" accept=".txt"/>

        <!-- <label for="textInput">Or write text below:</label>
        <textarea id="textInput" name="textInput" rows="8" placeholder="Type your input here..."></textarea> -->

        <input type="submit" value="Submit"/>
    </form>

    <c:if test="${not empty input}">
        <div class="result">
            <h3>Original Input:</h3>
            <pre>${input}</pre>
        </div>
    </c:if>

    <c:if test="${not empty result}">
        <div class="result">
            <h3>Processed Output:</h3>
            <pre>${result}</pre>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="error">
            <h3>Error:</h3>
            <p>${error}</p>
        </div>
    </c:if>
</div>
</body>
</html>
