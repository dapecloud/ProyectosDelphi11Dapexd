unit MyJsonClasses;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON, REST.Json;

type
  TCategory = class
  private
    FCategoryId: Integer;
    FCategoryName: string;
  public
    property CategoryId: Integer read FCategoryId write FCategoryId; // Agregar propiedad CategoryId
    property CategoryName: string read FCategoryName write FCategoryName;
  end;

  TSubChapter = class
  private
    FSubChapterId: Integer;
    FSubChapterName: string;
    FCategories: TArray<TCategory>;
  public
    property SubChapterId: Integer read FSubChapterId write FSubChapterId; // Agregar propiedad SubChapterId
    property SubChapterName: string read FSubChapterName write FSubChapterName;
    property Categories: TArray<TCategory> read FCategories;
  end;

  TChapter = class
  private
    FChapterId: Integer;
    FChapterName: string;
    FMatch: boolean;
    FSubChapterList: TArray<TSubChapter>;
    FCategories: TArray<TCategory>;
  public
    property ChapterId: Integer read FChapterId write FChapterId; // Agregar propiedad ChapterId
    property ChapterName: string read FChapterName write FChapterName;
    property Match: boolean read FMatch write FMatch;
    property SubChapterList: TArray<TSubChapter> read FSubChapterList;
    property Categories: TArray<TCategory> read FCategories;
  end;

  TJsonRoot = class
  private
    FResults: TArray<TChapter>;
  public
    class function FromJsonString(const AJson: string): TJsonRoot;
    property Results: TArray<TChapter> read FResults;
  end;

implementation

class function TJsonRoot.FromJsonString(const AJson: string): TJsonRoot;
begin
  Result := TJson.JsonToObject<TJsonRoot>(AJson);
end;

end.

