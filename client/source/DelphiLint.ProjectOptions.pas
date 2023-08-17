{
DelphiLint Client for RAD Studio
Copyright (C) 2023 Integrated Application Development

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
}
unit DelphiLint.ProjectOptions;

interface

uses
    DelphiLint.Properties
  ;

type
  TLintProjectOptions = class(TPropertiesFile)
  private
    FDir: string;
    function GetProjectBaseDirAbsolute: string;
    function GetProjectPropertiesPath: string;
  protected
    function RegisterFields: TArray<TPropFieldBase>; override;
  public
    constructor Create(Path: string);

    property SonarHostProjectKey: string index 0 read GetValueStr write SetValueStr;
    property SonarHostUrl: string index 1 read GetValueStr write SetValueStr;
    property SonarHostToken: string index 2 read GetValueStr write SetValueStr;
    property SonarHostDownloadPlugin: Boolean index 3 read GetValueBool write SetValueBool;
    property AnalysisBaseDir: string index 4 read GetValueStr write SetValueStr;
    property AnalysisReadProperties: Boolean index 5 read GetValueBool write SetValueBool;
    property AnalysisConnectedMode: Boolean index 6 read GetValueBool write SetValueBool;

    property AnalysisBaseDirAbsolute: string read GetProjectBaseDirAbsolute;
    property ProjectPropertiesPath: string read GetProjectPropertiesPath;
  end;

implementation

uses
    System.IOUtils
  , DelphiLint.Utils
  ;

//______________________________________________________________________________________________________________________

constructor TLintProjectOptions.Create(Path: string);
begin
  FDir := TPath.GetDirectoryName(Path);
  inherited Create(Path);
  Load;
end;

//______________________________________________________________________________________________________________________

function TLintProjectOptions.GetProjectBaseDirAbsolute: string;
begin
  Result := AnalysisBaseDir;
  if (Result <> '') and TPath.IsRelativePath(Result) then begin
    Result := ToAbsolutePath(Result, FDir);
  end;
end;

//______________________________________________________________________________________________________________________

function TLintProjectOptions.GetProjectPropertiesPath: string;
begin
  Result := '';
  if AnalysisReadProperties then begin
    Result := TPath.Combine(AnalysisBaseDirAbsolute, 'sonar-project.properties');
  end;
end;

//______________________________________________________________________________________________________________________

function TLintProjectOptions.RegisterFields: TArray<TPropFieldBase>;
begin
  Result := [
    // 0
    TStringPropField.Create('SonarHost', 'ProjectKey'),
    // 1
    TStringPropField.Create('SonarHost', 'Url'),
    // 2
    TStringPropField.Create('SonarHost', 'Token'),
    // 3
    TBoolPropField.Create('SonarHost', 'DownloadPlugin', True),
    // 4
    TStringPropField.Create('Analysis', 'BaseDir', '.'),
    // 5
    TBoolPropField.Create('Analysis', 'ReadProperties', True),
    // 6
    TBoolPropField.Create('Analysis', 'ConnectedMode', False)
  ];
end;

end.
