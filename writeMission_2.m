function writeMission_2( savePath, fileName, homePosition, startPosition, legAltitude, legHeading, headingOffset, legSpeed, legLength, legHoldTime, varargin )

% Defaults
cruiseSpeed = 15;
firmwareType = 12;
hoverSpeed = 5;
vehicleType = 2;
Version = 2;

% Check inputs
% Check for cruise speed
i = find( contains( varargin(1:2:end), {'cruise'}, 'IgnoreCase', true ) & contains( varargin(1:2:end), {'speed'}, 'IgnoreCase', true ), 1, 'first' );

if ~isempty( i )
    a = varargin{2*i};
    
    % Check if input is vector
    if isnumeric( a )
        cruiseSpeed = a(1);
        
    end
        
end

% Check for firmware type
i = find( contains( varargin(1:2:end), {'firm'}, 'IgnoreCase', true ), 1, 'first' );

if ~isempty( i )
    a = varargin{2*i};
    
    % Check if input is vector
    if isnumeric( a )
        firmwareType = a(1);
        
    end
        
end

% Check for hover speed
i = find( contains( varargin(1:2:end), {'hover'}, 'IgnoreCase', true ) & contains( varargin(1:2:end), {'speed'}, 'IgnoreCase', true ), 1, 'first' );

if ~isempty( i )
    a = varargin{2*i};
    
    % Check if input is vector
    if isnumeric( a )
        hoverSpeed = a(1);
        
    end
        
end

% Check for vehicle type
i = find( contains( varargin(1:2:end), {'vehicle'}, 'IgnoreCase', true ), 1, 'first' );

if ~isempty( i )
    a = varargin{2*i};
    
    % Check if input is vector
    if isnumeric( a )
        vehicleType = a(1);
        
    end
        
end

% Check for version
i = find( contains( varargin(1:2:end), {'version'}, 'IgnoreCase', true ), 1, 'first' );

if ~isempty( i )
    a = varargin{2*i};
    
    % Check if input is vector
    if isnumeric( a )
        Version = a(1);
        
    end
        
end

% Check path
if isempty( savePath ); savePath = pwd; end
if ~exist( savePath, 'dir' ); mkdir( savePath ); end

% Format inputs
homePosition = homePosition(:);
startPosition = startPosition(:)';

% Force leg parameters to be same length
varNames = whos( 'leg*' );
varNames = {varNames.name};
n = nan( 1, length( varNames ) );
for i = 1:length( varNames )
    eval( [varNames{i} '=' varNames{i} '(:);'] );
    n(i) = eval( ['length(' varNames{i} ')'] );
    
end

nn = min( n(n~=1) );
if isempty( nn ); nn = 1; end

if nn == 0
    warning( 'Insufficient data.' )
    return
    
end

if nn > 1
    for i = 1:length( varNames )
        if n(i) == 1
            eval( [varNames{i} '=repmat(' varNames{i} ',' num2str( nn ) ',1);'] );
            
        elseif n(i) > nn
            eval( [varNames{i} '=' varNames{i} '(1:' num2str( nn ) ');'] );
            
        end

    end
    
end

% Wrap heading
legHeading = wrapTo360( legHeading );

% Create lat/lon
% Add start position!
dx = [0; cumsum( legLength.*cosd( 90-legHeading ) )];
dy = [0; cumsum( legLength.*sind( 90-legHeading ) )];

[lla(:,1), lla(:,2), lla(:,3)]= enu2geodetic( dx, dy, zeros( size( dx ) ), startPosition(1), startPosition(2), 0, wgs84Ellipsoid );

legAltitude = [legAltitude(1);legAltitude];
legHeading = [legHeading(1);legHeading];
vehicleHeading = wrapTo360( legHeading + headingOffset );
legSpeed = [legSpeed(1);legSpeed];
legHoldTime = [legHoldTime;0];
nn = nn+1;

% Create structure
a.fileType = 'Plan';
a.geoFence.circles = [];
a.geoFence.polygons = [];
a.geoFence.version = [];

a.groundStation = 'QGroundControl';

a.mission.cruiseSpeed = cruiseSpeed;
a.mission.firmwareType = firmwareType;
a.mission.hoverSpeed = hoverSpeed;

for i = 1:nn
    ii = 2*i-1;
    a.mission.items{ii}.AMSLAltAboveTerrain = legAltitude(i);
    a.mission.items{ii}.Altitude = legAltitude(i);
    a.mission.items{ii}.AltitudeMode = 1;
    a.mission.items{ii}.autoContinue = true;
    a.mission.items{ii}.command = 16;
    a.mission.items{ii}.doJumpId = ii;
    a.mission.items{ii}.frame = 3;
    a.mission.items{ii}.params = [legHoldTime(i);0;0;vehicleHeading(i);lla(i,1);lla(i,2);legAltitude(i)];
    a.mission.items{ii}.type = 'SimpleItem';
    
    if i == nn
        a.mission.items{ii}.command = 17;
        a.mission.items{ii}.params(3) = 50;
        
    else
        a.mission.items{ii+1}.autoContinue = true;
        a.mission.items{ii+1}.command = 178;
        a.mission.items{ii+1}.doJumpId = ii+1;
        a.mission.items{ii+1}.frame = 2;
        a.mission.items{ii+1}.params = [1;legSpeed(i);-1;0;0;0;0];
        a.mission.items{ii+1}.type = 'SimpleItem';
        
    end
    
end

a.mission.plannedHomePosition = homePosition;
a.mission.vehicleType = vehicleType;
a.mission.version = Version;

a.rallyPoints.points = [];
a.rallyPoints.version = 2;

a.version = 1;

% Write data
fid = fopen( fullfile( savePath, fileName ), 'w' );
fprintf( fid, jsonencode( a ) );
fclose( fid );

end