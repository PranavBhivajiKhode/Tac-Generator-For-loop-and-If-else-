package CD.Project.TAC;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
public class InputController {
	
	private TACGenerator tacGenerator;
	
    public InputController(TACGenerator tacGenerator) {
		super();
		this.tacGenerator = tacGenerator;
	}

	@GetMapping("/input")
    public String showInputPage() {
        return "input"; // input.jsp
    }

    @PostMapping("/processInput")
    public String handleInput(
            @RequestParam(required = false) MultipartFile fileInput,
            @RequestParam(required = false) String textInput,
            ModelMap model) {

        String originalInput = "";
        String result = "";

        try {
            if (fileInput != null) {
                BufferedReader reader = new BufferedReader(
                        new InputStreamReader(fileInput.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
                originalInput = sb.toString();
            }else {
                model.put("error", "⚠️ No input provided.");
                return "input";
            }
            
            List<String> preResult = tacGenerator.Generator(originalInput);
            
            for(String s : preResult) {
            	System.out.println(s);
            }
            
            for(String parts : preResult) {
            	result = result + "\n" + parts;
            }
            

            model.put("input", originalInput);
            model.put("result", result);
            return "input";

        } catch (Exception e) {
            model.put("error", "❌ Error: " + e.getMessage());
            return "input";
        }
    }
}
