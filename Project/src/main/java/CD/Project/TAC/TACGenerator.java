package CD.Project.TAC;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class TACGenerator {
    static int tempCounter = 1;
    static int lineCounter = 1;
    static List<String> tac = new ArrayList<>();

    static String newTemp() {
        return "T" + tempCounter++;
    }

    static void generateStatement(String stmt) {
        stmt = stmt.trim();
        if (!stmt.contains("=")) return;

        String[] parts = stmt.split("=");
        String lhs = parts[0].trim();
        String rhs = parts[1].trim();

        char op = ' ';
        for (char c : new char[]{'+', '-', '*', '/'}) {
            if (rhs.contains(String.valueOf(c))) {
                op = c;
                break;
            }
        }

        if (op != ' ') {
            String[] operands = rhs.split("\\" + op);
            String temp = newTemp();
            tac.add(lineCounter++ + ") " + temp + " = " + operands[0].trim() + " " + op + " " + operands[1].trim());
            tac.add(lineCounter++ + ") " + lhs + " = " + temp);
        } else {
            tac.add(lineCounter++ + ") " + lhs + " = " + rhs);
        }
    }

    static int generateIfElse(List<List<String>> conditions, List<List<String>> blocks, boolean inLoop, int loopContinueLine) {
        int nextCheckLine = lineCounter;

        for (int i = 0; i < conditions.size(); i++) {
            List<String> cond = conditions.get(i);
            List<String> block = blocks.get(i);

            tac.add(lineCounter++ + ") if (" + cond.get(0) + ") goto " + (lineCounter+1));

            int falseJumpLine = lineCounter + (block.size() * 2) + 2;
            tac.add(lineCounter++ + ") goto " + falseJumpLine);

            for (String stmt : block) {
                generateStatement(stmt);
            }

            tac.add(lineCounter++ + ") goto END");
//            tac.add(lineCounter++ + ") goto " + (inLoop ? loopContinueLine : falseJumpLine + 1));

            nextCheckLine = lineCounter;
        }

        // Final else block
        if (conditions.size() < blocks.size()) {
            List<String> elseBlock = blocks.get(blocks.size() - 1);
            for (String stmt : elseBlock) {
                generateStatement(stmt);
            }
        }
        tac.add(lineCounter++ + ") goto END");

//        tac.add(lineCounter++ + ") goto " + (inLoop ? loopContinueLine : lineCounter));

        return lineCounter;
    }



    static void generateFor(String init, String cond, String inc, List<String> body) {
        generateStatement(init);

        int condCheck = lineCounter;
        tac.add(lineCounter++ + ") if (" + cond + ") goto " + (lineCounter + 1));
        int exitLoop = lineCounter;
        tac.add(lineCounter++ + ") goto X"); // Placeholder for exit

        int loopBodyStart = lineCounter;

        for (int idx = 0; idx < body.size(); idx++) {
            String current = body.get(idx).trim();

            if (current.startsWith("for")) {
                // Extract inner for loop parts
                String innerInit = current.substring(current.indexOf('(') + 1, current.indexOf(';')).trim();
                String innerCond = current.substring(current.indexOf(';') + 1, current.lastIndexOf(';')).trim();
                String innerInc = current.substring(current.lastIndexOf(';') + 1, current.indexOf(')')).trim();

                idx++;
                List<String> innerBody = new ArrayList<>();

                while (idx < body.size()) {
                    if(idx == body.size()-1){
                        if(!body.get(idx).equals("}")){
                            innerBody.add(body.get(idx));
                        }
                    }else{
                        innerBody.add(body.get(idx).trim());
                    }
                    idx++;
                }

                generateFor(innerInit, innerCond, innerInc, innerBody); // Recursive Call for nested for

            } else if (current.startsWith("if")) {
                String mainCondition = current.substring(current.indexOf('(') + 1, current.indexOf(')')).trim();

                List<List<String>> conditions = new ArrayList<>();
                List<List<String>> blocks = new ArrayList<>();

                // if block
                List<String> trueBlock = new ArrayList<>();
                idx++;
                while (idx < body.size() && !body.get(idx).equals("}")) {
                    trueBlock.add(body.get(idx).trim());
                    idx++;
                }
                blocks.add(trueBlock);

                idx++; // Move after if block

                // else-if and else handling
                while (idx < body.size() && body.get(idx).trim().startsWith("else")) {
                    String line = body.get(idx).trim();

                    if (line.startsWith("else if")) {
                        String elseifCondition = line.substring(line.indexOf('(') + 1, line.indexOf(')')).trim();
                        List<String> elseifBlock = new ArrayList<>();

                        idx++;
                        while (idx < body.size() && !body.get(idx).equals("}")) {
                            elseifBlock.add(body.get(idx).trim());
                            idx++;
                        }

                        conditions.add(Arrays.asList(elseifCondition));  // Storing condition
                        blocks.add(elseifBlock);  // Storing block
                        idx++; // after }

                    } else { // else block
                        List<String> elseBlock = new ArrayList<>();
                        idx++;
                        while (idx < body.size() && !body.get(idx).equals("}")) {
                            elseBlock.add(body.get(idx).trim());
                            idx++;
                        }
                        blocks.add(elseBlock);
                        idx++; // after }
                        break;
                    }
                }

                generateIfElse(conditions, blocks, true, condCheck + 1);
            }else {
                generateStatement(current);
            }
        }

        tac.add(lineCounter++ + ") " + inc);
        tac.add(lineCounter++ + ") goto " + condCheck);

        int endLine = lineCounter++;
        tac.set(exitLoop - 1, exitLoop + ") goto " + endLine);
        tac.add(endLine + ") END");
    }


    public List<String> Generator(String input) {
        tempCounter = 1;
        lineCounter = 1;
        tac.clear();

        try {
            String[] lines = input.split("\n");

            for (int idx = 0; idx < lines.length; idx++) {
                String line = lines[idx].trim();

                if (line.startsWith("for")) {
                    int open = line.indexOf('('), close = line.indexOf(')');
                    String[] parts = line.substring(open + 1, close).split(";");
                    String init = parts[0].trim();
                    String cond = parts[1].trim();
                    String inc = parts[2].trim();

                    List<String> body = new ArrayList<>();
                    idx++; // skip {

                    while (!lines[idx].trim().equals("}")) {
                        body.add(lines[idx].trim());
                        idx++;
                    }

                    generateFor(init, cond, inc, body);
                } else if (line.startsWith("if")) {
                    List<List<String>> conditions = new ArrayList<>();
                    List<List<String>> blocks = new ArrayList<>();

                    String ifCondition = line.substring(line.indexOf('(') + 1, line.indexOf(')')).trim();
                    conditions.add(Arrays.asList(ifCondition));

                    idx++; // skip {

                    // if block
                    List<String> trueBlock = new ArrayList<>();
                    while (!lines[idx].trim().equals("}")) {
                        trueBlock.add(lines[idx].trim());
                        idx++;
                    }
                    blocks.add(trueBlock);
                    idx++; // skip }

                    // else-if & else block handling
                    while (idx < lines.length && lines[idx].trim().startsWith("else")) {
                        String nextLine = lines[idx].trim();

                        if (nextLine.startsWith("else if")) {
                            String elseifCondition = nextLine.substring(nextLine.indexOf('(') + 1, nextLine.indexOf(')')).trim();
                            conditions.add(Arrays.asList(elseifCondition)); // store condition

                            idx++; // skip {

                            List<String> elseifBlock = new ArrayList<>();
                            while (!lines[idx].trim().equals("}")) {
                                elseifBlock.add(lines[idx].trim());
                                idx++;
                            }
                            blocks.add(elseifBlock);
                            idx++; // skip }
                        } else { // else block
                            idx++; // skip {
                            List<String> elseBlock = new ArrayList<>();
                            while (!lines[idx].trim().equals("}")) {
                                elseBlock.add(lines[idx].trim());
                                idx++;
                            }
                            blocks.add(elseBlock);
                            idx++; // skip }
                            break;
                        }
                    }

                    generateIfElse(conditions, blocks, false, -1);
                }else if (!line.isEmpty()) {
                    generateStatement(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tac;
    }
}