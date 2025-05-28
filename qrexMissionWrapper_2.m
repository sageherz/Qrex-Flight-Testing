function qrexMissionWrapper_2( savePath, fileName, homePosition, legAltitude, legHeading, headingOffset, legSpeed, legLength, legHoldTime )
% Check inputs
% Format inputs
legAltitude = legAltitude(1);
legHeading = legHeading(1);
legHoldTime = legHoldTime(1);
legLength = legLength(:);
legSpeed = legSpeed(:);

% Check vector lengths
if (length( legLength ) - length( legSpeed )) ~= 0
    warning( 'Leg length and speed vectors of different length - truncating cases.' )
    
    n = min( length( legLength ), length( legSpeed ) );
    legLength = legLength(1:n);
    legSpeed = legSpeed(1:n);
    
end

% Home Position
if length( homePosition ) == 2; homePosition(3) = legAltitude; end

% Start position
[startPosition(1), startPosition(2)] = enu2geodetic( legLength(1)/2*cosd( 90-legHeading-180 ), legLength(1)/2*sind( 90-legHeading-180 ), 0, homePosition(1), homePosition(2), 0, wgs84Ellipsoid );

% Leg speed
legSpeed = legSpeed(:)';
legSpeed = repmat( legSpeed, 2, 1 );
legSpeed = legSpeed(:);
n = length( legSpeed );

% Correct leg speed array
legSpeed(1) = [];
legSpeed(end+1) = legSpeed(end);

% Leg heading
legHeading = repmat( legHeading, n, 1 );
legHeading(2:2:end) = legHeading(2:2:end)+180;
legHeading = wrapTo360( legHeading );

% Heading offset
headingOff = zeros( 2+2*length( headingOffset ), 1 );
for i = 1:length( headingOffset )
    ind = i+i;
    headingOff(ind) = headingOffset(i);
    headingOff(ind+1) = headingOffset(i);
end    
%headingOff(end) = 90;

% Leg length
legLength = legLength(:)';
legLength = repmat( legLength, 2, 1 );
legLength = legLength(:);

% Return to start position
legSpeed(end+1) = legSpeed(end);
legHeading(end+1) = legHeading(1);
legLength(end+1) = legLength(1)/2;

% Create mission file
writeMission_2( savePath, fileName, homePosition, startPosition, legAltitude, legHeading, headingOff, legSpeed, legLength, legHoldTime )

end