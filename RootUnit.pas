unit RootUnit;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TCategories = class;
  TSubChapterList = class;

  TCategories = class
  private
    FCategoryName: string;
  published
    property CategoryName: string read FCategoryName write FCategoryName;
  end;

  TSubChapterList = class(TJsonDTO)
  private
    [JSONName('categories'), JSONMarshalled(False)]
    FCategoriesArray: TArray<TCategories>;
    [GenericListReflect]
    FCategories: TObjectList<TCategories>;
    FSubChapterName: string;
    function GetCategories: TObjectList<TCategories>;
  protected
    function GetAsJson: string; override;
  published
    property Categories: TObjectList<TCategories> read GetCategories;
    property SubChapterName: string read FSubChapterName write FSubChapterName;
  public
    destructor Destroy; override;
  end;
  
  TResults = class(TJsonDTO)
  private
    [JSONName('categories'), JSONMarshalled(False)]
    FCategoriesArray: TArray<TCategories>;
    [GenericListReflect]
    FCategories: TObjectList<TCategories>;
    FChapterName: string;
    [JSONName('subChapterList'), JSONMarshalled(False)]
    FSubChapterListArray: TArray<TSubChapterList>;
    [GenericListReflect]
    FSubChapterList: TObjectList<TSubChapterList>;
    function GetCategories: TObjectList<TCategories>;
    function GetSubChapterList: TObjectList<TSubChapterList>;
  protected
    function GetAsJson: string; override;
  published
    property Categories: TObjectList<TCategories> read GetCategories;
    property ChapterName: string read FChapterName write FChapterName;
    property SubChapterList: TObjectList<TSubChapterList> read GetSubChapterList;
  public
    destructor Destroy; override;
  end;
  
  TRoot = class(TJsonDTO)
  private
    [JSONName('results'), JSONMarshalled(False)]
    FResultsArray: TArray<TResults>;
    [GenericListReflect]
    FResults: TObjectList<TResults>;
    function GetResults: TObjectList<TResults>;
  protected
    function GetAsJson: string; override;
  published
    property Results: TObjectList<TResults> read GetResults;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TSubChapterList }

destructor TSubChapterList.Destroy;
begin
  GetCategories.Free;
  inherited;
end;

function TSubChapterList.GetCategories: TObjectList<TCategories>;
begin
  Result := ObjectList<TCategories>(FCategories, FCategoriesArray);
end;

function TSubChapterList.GetAsJson: string;
begin
  RefreshArray<TCategories>(FCategories, FCategoriesArray);
  Result := inherited;
end;

{ TResults }

destructor TResults.Destroy;
begin
  GetCategories.Free;
  GetSubChapterList.Free;
  inherited;
end;

function TResults.GetCategories: TObjectList<TCategories>;
begin
  Result := ObjectList<TCategories>(FCategories, FCategoriesArray);
end;

function TResults.GetSubChapterList: TObjectList<TSubChapterList>;
begin
  Result := ObjectList<TSubChapterList>(FSubChapterList, FSubChapterListArray);
end;

function TResults.GetAsJson: string;
begin
  RefreshArray<TCategories>(FCategories, FCategoriesArray);
  RefreshArray<TSubChapterList>(FSubChapterList, FSubChapterListArray);
  Result := inherited;
end;

{ TRoot }

destructor TRoot.Destroy;
begin
  GetResults.Free;
  inherited;
end;

function TRoot.GetResults: TObjectList<TResults>;
begin
  Result := ObjectList<TResults>(FResults, FResultsArray);
end;

function TRoot.GetAsJson: string;
begin
  RefreshArray<TResults>(FResults, FResultsArray);
  Result := inherited;
end;

end.
