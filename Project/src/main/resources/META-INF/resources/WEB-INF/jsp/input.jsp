<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Text Processor</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap">
    <style>
        :root {
            --primary: #4361ee;
            --primary-hover: #3a56d4;
            --background: #f8fafc;
            --card-bg: #ffffff;
            --text: #1e293b;
            --text-light: #64748b;
            --border: #e2e8f0;
            --success-bg: #f0fdf4;
            --success-border: #10b981;
            --error-bg: #fef2f2;
            --error-border: #ef4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--background);
            color: var(--text);
            line-height: 1.6;
            padding: 40px 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background: var(--card-bg);
            padding: 40px;
            width: 100%;
            max-width: 700px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        h2 {
            color: var(--text);
            font-weight: 700;
            font-size: 24px;
            margin-bottom: 24px;
            text-align: center;
        }

        h3 {
            font-size: 18px;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 8px;
            color: var(--text);
        }

        .file-input-container {
            position: relative;
            border: 2px dashed var(--border);
            border-radius: 12px;
            padding: 30px 20px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 24px;
        }

        .file-input-container:hover {
            border-color: var(--primary);
            background-color: rgba(67, 97, 238, 0.03);
        }

        .file-input-container svg {
            width: 48px;
            height: 48px;
            margin-bottom: 12px;
            color: var(--primary);
        }

        .file-input-container p {
            color: var(--text-light);
            margin-bottom: 8px;
        }

        .file-input-container strong {
            color: var(--primary);
        }

        input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        textarea {
            width: 100%;
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            resize: vertical;
            min-height: 150px;
            transition: border-color 0.3s ease;
        }

        textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        button[type="submit"] {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        button[type="submit"]:hover {
            background-color: var(--primary-hover);
        }

        button[type="submit"]:active {
            transform: translateY(1px);
        }

        .result, .error {
            margin-top: 30px;
            padding: 20px;
            border-radius: 12px;
        }

        .result {
            background-color: var(--success-bg);
            border-left: 5px solid var(--success-border);
        }

        .error {
            background-color: var(--error-bg);
            border-left: 5px solid var(--error-border);
            color: #b91c1c;
        }

        pre {
            background: rgba(0, 0, 0, 0.03);
            padding: 12px;
            border-radius: 8px;
            overflow-x: auto;
            font-family: monospace;
            font-size: 14px;
            margin-top: 8px;
        }

        .file-name {
            display: none;
            margin-top: 10px;
            font-size: 14px;
            color: var(--text);
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Text Processor</h2>

    <form action="/processInput" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="fileInput">Upload a text file</label>
            <div class="file-input-container" id="dropArea">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                </svg>
                <p>Drag and drop your file here or <strong>browse</strong></p>
                <p class="text-sm">Supports .txt files</p>
                <input type="file" id="fileInput" name="fileInput" accept=".txt"/>
                <div id="fileName" class="file-name"></div>
            </div>
        </div>

        <!-- Uncomment if you want to enable text input option
        <div class="form-group">
            <label for="textInput">Or write text below:</label>
            <textarea id="textInput" name="textInput" placeholder="Type your input here..."></textarea>
        </div>
        -->

        <button type="submit">Process Text</button>
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

<script>
    // Display file name when selected
    document.getElementById('fileInput').addEventListener('change', function(e) {
        const fileName = e.target.files[0] ? e.target.files[0].name : '';
        const fileNameElement = document.getElementById('fileName');
        
        if (fileName) {
            fileNameElement.textContent = 'Selected file: ' + fileName;
            fileNameElement.style.display = 'block';
        } else {
            fileNameElement.style.display = 'none';
        }
    });

    // Drag and drop functionality
    const dropArea = document.getElementById('dropArea');
    
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropArea.addEventListener(eventName, preventDefaults, false);
    });
    
    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }
    
    ['dragenter', 'dragover'].forEach(eventName => {
        dropArea.addEventListener(eventName, highlight, false);
    });
    
    ['dragleave', 'drop'].forEach(eventName => {
        dropArea.addEventListener(eventName, unhighlight, false);
    });
    
    function highlight() {
        dropArea.style.borderColor = 'var(--primary)';
        dropArea.style.backgroundColor = 'rgba(67, 97, 238, 0.05)';
    }
    
    function unhighlight() {
        dropArea.style.borderColor = 'var(--border)';
        dropArea.style.backgroundColor = 'transparent';
    }
    
    dropArea.addEventListener('drop', handleDrop, false);
    
    function handleDrop(e) {
        const dt = e.dataTransfer;
        const files = dt.files;
        document.getElementById('fileInput').files = files;
        
        const fileName = files[0] ? files[0].name : '';
        const fileNameElement = document.getElementById('fileName');
        
        if (fileName) {
            fileNameElement.textContent = 'Selected file: ' + fileName;
            fileNameElement.style.display = 'block';
        }
    }
</script>
</body>
</html>