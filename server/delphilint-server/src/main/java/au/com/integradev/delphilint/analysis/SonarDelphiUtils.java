package au.com.integradev.delphilint.analysis;

public class SonarDelphiUtils {
  private SonarDelphiUtils() {
    // Utility class
  }

  public static String convertSonarDelphiError(String sonarDelphiException) {
    String sonarDelphiError = sonarDelphiException.split("\n", 2)[0];

    if (sonarDelphiError.contains("DelphiFileConstructionException")) {
      String antlrError = sonarDelphiError.replaceFirst("^.*\\((.*?)\\)$", "$1").replace("\r", "");
      return "A Delphi file could not be parsed (" + antlrError + ")";
    } else if (sonarDelphiError.contains("NullPointerException")) {
      return "A null pointer exception was raised";
    } else {
      return "An error was raised (" + sonarDelphiError + ")";
    }
  }
}