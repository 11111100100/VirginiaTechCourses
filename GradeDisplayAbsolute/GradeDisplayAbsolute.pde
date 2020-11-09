void setup() {
  surface.setVisible(false);

  JSONArray values;
  values = loadJSONArray("individual_classes.json");

  println(values.size());
  for (int current = 0; current < values.size(); current++) {
    JSONObject currentJSONObject = values.getJSONObject(current);

    String courseName = currentJSONObject.getString("Course Title");
    int credits = currentJSONObject.getInt("Credits");
    float GPAValue = currentJSONObject.getFloat("GPA");
    String courseNumber = currentJSONObject.getString("Identifier") + " (" + credits + (credits == 1 ? " Credit" : " Credits") + ")";
    char[] letters = new char[] {'A', 'B', 'C', 'D', 'F'};
    float[] percentage = new float[letters.length];
    for (int i = 0; i < letters.length; i++) {
      percentage[i] = currentJSONObject.getFloat(letters[i] + " (%)") / 100;
    }


    int multiplyer = 2;
    PGraphics pg;
    pg = createGraphics(700*multiplyer, 900*multiplyer);
    pg.beginDraw();

    int rectRadiusMax = multiplyer*40;

    PVector mainRectDim = new PVector(pg.width * 0.9, pg.height - (pg.width * 0.1));

    PVector topRectDim = new PVector(mainRectDim.x, mainRectDim.y * 2 / 9.0);
    PVector topRectPos = new PVector(pg.width / 2 - topRectDim.x / 2, (pg.width - mainRectDim.x) / 2);

    PVector bottomRectDim = new PVector(mainRectDim.x, mainRectDim.y * 7 / 9.0);
    PVector bottomRectPos = new PVector(topRectPos.x, topRectPos.y + topRectDim.y);

    pg.noStroke();
    pg.fill(150);
    pg.rect(0, 0, pg.width, pg.height, rectRadiusMax, rectRadiusMax, rectRadiusMax, rectRadiusMax);
    pg.fill(100);
    pg.rect(topRectPos.x, topRectPos.y, topRectDim.x, topRectDim.y, rectRadiusMax / 2, rectRadiusMax / 2, 0, 0);
    pg.fill(200);
    pg.rect(bottomRectPos.x, bottomRectPos.y, bottomRectDim.x, bottomRectDim.y, 0, 0, rectRadiusMax / 2, rectRadiusMax / 2);

    float textSize = (topRectDim.y * 0.6) / 3;
    pg.textSize(textSize);
    pg.textAlign(CENTER, TOP);
    pg.fill(255);
    pg.text("Grade Distribution For:", topRectPos.x / 2 + topRectDim.x / 2, topRectPos.y + (textSize * 1.5) - textSize);
    pg.text(courseName, topRectPos.x / 2 + topRectDim.x / 2, topRectPos.y + (textSize * 1.5) * 2 - textSize);
    pg.text(courseNumber, topRectPos.x / 2 + topRectDim.x / 2, topRectPos.y + (textSize * 1.5) * 3 - textSize);

    float axisLength = 450 * multiplyer;
    PVector commonPoint = new PVector((bottomRectPos.x + bottomRectDim.x / 2) - axisLength / 2, (bottomRectPos.y + bottomRectDim.y / 2) + axisLength / 2);
    float axisWeight = multiplyer * 10;
    pg.strokeWeight(axisWeight);
    pg.strokeCap(PROJECT);
    pg.stroke(0);
    pg.line(commonPoint.x, commonPoint.y, commonPoint.x + axisLength, commonPoint.y);
    pg.line(commonPoint.x, commonPoint.y, commonPoint.x, commonPoint.y - axisLength);

    color[] baseColor = new color[] {#DD5856, #E9A33E, #E2E287, #86BE86, #91B1BE, #BE8EBB};
    color[] highlightColor = new color[] {#FF6663, #FEB144, #FDFD97, #94D294, #99BBC8, #CC99C9};
    float percentageMultiplyer = 1 / max(percentage) * 0.85;
    pg.noStroke();
    for (int i = 0; i < percentage.length; i++) {
      float barHeight = percentage[i] * percentageMultiplyer * axisLength;
      float barHeightText = max(percentage[i] * percentageMultiplyer * axisLength, 0.08 * axisLength);
      float barWidth = axisLength / percentage.length;
      float smallBarWidth = barWidth * 0.9;
      float barX = (commonPoint.x + (axisWeight / 2)) + (i * barWidth); 
      float barY = (commonPoint.y - (axisWeight / 2)) - barHeight;
      float barYText = (commonPoint.y - (axisWeight / 2)) - barHeightText;
      pg.fill(baseColor[i]);
      pg.rect(barX, barY, barWidth, barHeight, rectRadiusMax / 4, rectRadiusMax / 4, 0, 0);
      pg.fill(highlightColor[i]);
      pg.rect((barWidth * 0.1) + barX, barY, smallBarWidth, barHeight, 0, rectRadiusMax / 4, 0, rectRadiusMax);
      pg.fill(0, 75);
      pg.textSize(textSize);
      pg.textAlign(CENTER, BOTTOM);
      pg.text(getLetterFor(i), barX + barWidth / 2 - (rectRadiusMax * 0.05), barYText - rectRadiusMax / 10 + (rectRadiusMax * 0.05));
      pg.fill(0);
      pg.text(getLetterFor(i), barX + barWidth / 2, barYText - rectRadiusMax / 10);
      pg.fill(0, 100);
      pg.textAlign(CENTER, TOP);
      pg.textSize(textSize / 2);
      pg.text(formatPercentage(percentage[i], 2), barX + barWidth / 2, barYText + rectRadiusMax / 5);
    }

    pg.noStroke();
    pg.textAlign(CENTER, BOTTOM);
    pg.textSize(textSize * 2);
    pg.fill(0, 100);
    pg.text("Grades", pg.width / 2 - textSize * 0.05, pg.height * 0.95 + textSize * 0.05);
    pg.fill(0);
    pg.text("Grades", pg.width / 2, pg.height * 0.95);

    pg.textAlign(CENTER, CENTER);
    pg.textSize(textSize);
    pg.pushMatrix();
    pg.translate(pg.width * 0.1 + textSize * 0.05, pg.height * 0.05 + topRectDim.y + bottomRectDim.y / 2);
    pg.rotate(-PI / 2);
    pg.fill(0, 100);
    pg.text("Percentage Of Class", textSize * -0.05, textSize * 0.05);
    pg.fill(0);
    pg.text("Percentage Of Class", 0, 0);
    pg.popMatrix();

    pg.textAlign(CENTER, TOP);
    pg.textSize(textSize * 1.5);
    pg.fill(0, 100);
    pg.text("Average GPA: " + GPAValue, pg.width / 2 - textSize * 0.05, bottomRectPos.y + textSize * 0.25 + textSize * 0.05);
    pg.fill(0);
    pg.text("Average GPA: " + GPAValue, pg.width / 2, bottomRectPos.y + textSize * 0.25);

    pg.textSize(textSize / 2);
    pg.fill(0, 200);
    pg.textAlign(RIGHT, BOTTOM);
    pg.text("Enrollment: " + currentJSONObject.getInt("Enrollment"), pg.width / 2 - textSize, bottomRectPos.y + textSize * 2.75);
    pg.textAlign(LEFT, BOTTOM);
    pg.text("Withdraws: " + currentJSONObject.getInt("Withdraws"), pg.width / 2 + textSize, bottomRectPos.y + textSize * 2.75);

    pg.endDraw();
    pg.save("sortedAlpha/" + currentJSONObject.getString("Identifier") + ".png");
  }
}

String formatPercentage(float num, int numberOfPlaces) {
  String full = (num * 100) + nf(0, numberOfPlaces + 1);
  return full.substring(0, full.indexOf(".") + (1 + numberOfPlaces)) + "%";
}

char getLetterFor(int i) {
  return (i == 4 ? 'F' : char(i + int('A')));
}
