public class BluescapeParser {

    public static List<List<String> > parseCSV(String contents, Boolean skipHeaders)
    {
        List<List<String> > rows = new List<List<String> >();
        contents = contents.replaceAll(',"""',',"DBLQT').replaceAll('""",','DBLQT",');
        contents = contents.replaceAll('""','DBLQT');

        List<String> lines = contents.split('\n');

        if (lines.size() < 2) {
            lines = contents.split('\r');
        }

        if (lines.size() < 2) {
          throw new StringException('no new lines found in csv file');
        }

        Integer num = 0;

        for(String line : lines)
        {
            List<String> row = parseRow(line);

            if (row != null)
            {
                rows.add(row);
            }
        }

        if (skipHeaders) rows.remove(0);

        return rows;
    }

    public static List<String> parseRow(String line)
    {
        if (line.replaceAll(',','').trim().length() == 0) return null;

        List<String> row = new List<String>();
        List<String> fields = line.split(',');
        String compositeField;
        Boolean makeCompositeField = false;

        for(String field : fields)
        {
            if (field.startsWith('"') && field.endsWith('"')) {
                field = field.removeStart('"').removeEnd('"').replaceAll('DBLQT','"');
                row.add(field);
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                compositeField = compositeField.removeStart('"').removeEnd('"').replaceAll('DBLQT','"');
                row.add(compositeField);
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {
                field = field.removeStart('"').removeEnd('"').replaceAll('DBLQT','"');
                row.add(field);
            }
        }

        return row;
    }
}