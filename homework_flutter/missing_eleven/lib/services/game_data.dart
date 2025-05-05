import '../models/player.dart';
import '../models/team.dart';
import '../models/match.dart';

class GameData {
  static final List<Player> players = [
    // Barcelona players
    Player(id: 'p1', name: 'Ter Stegen', position: 'GK'),
    Player(id: 'p2', name: 'Dest', position: 'RB'),
    Player(id: 'p3', name: 'Piqué', position: 'CB'),
    Player(id: 'p4', name: 'Lenglet', position: 'CB'),
    Player(id: 'p5', name: 'Alba', position: 'LB'),
    Player(id: 'p6', name: 'Busquets', position: 'CDM'),
    Player(id: 'p7', name: 'De Jong', position: 'CM'),
    Player(id: 'p8', name: 'Pedri', position: 'CM'),
    Player(id: 'p9', name: 'Messi', position: 'RW'),
    Player(id: 'p10', name: 'Griezmann', position: 'ST'),
    Player(id: 'p11', name: 'Dembélé', position: 'LW'),
    
    // Real Madrid players
    Player(id: 'p12', name: 'Courtois', position: 'GK'),
    Player(id: 'p13', name: 'Carvajal', position: 'RB'),
    Player(id: 'p14', name: 'Varane', position: 'CB'),
    Player(id: 'p15', name: 'Ramos', position: 'CB'),
    Player(id: 'p16', name: 'Mendy', position: 'LB'),
    Player(id: 'p17', name: 'Casemiro', position: 'CDM'),
    Player(id: 'p18', name: 'Kroos', position: 'CM'),
    Player(id: 'p19', name: 'Modric', position: 'CM'),
    Player(id: 'p20', name: 'Asensio', position: 'RW'),
    Player(id: 'p21', name: 'Benzema', position: 'ST'),
    Player(id: 'p22', name: 'Hazard', position: 'LW'),
    
    // Liverpool players
    Player(id: 'p23', name: 'Alisson', position: 'GK'),
    Player(id: 'p24', name: 'Alexander-Arnold', position: 'RB'),
    Player(id: 'p25', name: 'Van Dijk', position: 'CB'),
    Player(id: 'p26', name: 'Gomez', position: 'CB'),
    Player(id: 'p27', name: 'Robertson', position: 'LB'),
    Player(id: 'p28', name: 'Henderson', position: 'CM'),
    Player(id: 'p29', name: 'Fabinho', position: 'CDM'),
    Player(id: 'p30', name: 'Thiago', position: 'CM'),
    Player(id: 'p31', name: 'Salah', position: 'RW'),
    Player(id: 'p32', name: 'Firmino', position: 'ST'),
    Player(id: 'p33', name: 'Mané', position: 'LW'),

    // Manchester City players
    Player(id: 'p34', name: 'Ederson', position: 'GK'),
    Player(id: 'p35', name: 'Walker', position: 'RB'),
    Player(id: 'p36', name: 'Dias', position: 'CB'),
    Player(id: 'p37', name: 'Laporte', position: 'CB'),
    Player(id: 'p38', name: 'Cancelo', position: 'LB'),
    Player(id: 'p39', name: 'Rodri', position: 'CDM'),
    Player(id: 'p40', name: 'De Bruyne', position: 'CM'),
    Player(id: 'p41', name: 'Silva', position: 'CM'),
    Player(id: 'p42', name: 'Mahrez', position: 'RW'),
    Player(id: 'p43', name: 'Haaland', position: 'ST'),
    Player(id: 'p44', name: 'Phil Foden', position: 'LW'),

    // Bayern Munich players
    Player(id: 'p45', name: 'Neuer', position: 'GK'),
    Player(id: 'p46', name: 'Pavard', position: 'RB'),
    Player(id: 'p47', name: 'Upamecano', position: 'CB'),
    Player(id: 'p48', name: 'Hernández', position: 'CB'),
    Player(id: 'p49', name: 'Davies', position: 'LB'),
    Player(id: 'p50', name: 'Kimmich', position: 'CDM'),
    Player(id: 'p51', name: 'Goretzka', position: 'CM'),
    Player(id: 'p52', name: 'Müller', position: 'CM'),
    Player(id: 'p53', name: 'Coman', position: 'RW'),
    Player(id: 'p54', name: 'Lewandowski', position: 'ST'),
    Player(id: 'p55', name: 'Sané', position: 'LW'),

    // Paris Saint-Germain players
    Player(id: 'p56', name: 'Donnarumma', position: 'GK'),
    Player(id: 'p57', name: 'Hakimi', position: 'RB'),
    Player(id: 'p58', name: 'Marquinhos', position: 'CB'),
    Player(id: 'p59', name: 'Ramos', position: 'CB'),
    Player(id: 'p60', name: 'Mendes', position: 'LB'),
    Player(id: 'p61', name: 'Verratti', position: 'CDM'),
    Player(id: 'p62', name: 'Paredes', position: 'CM'),
    Player(id: 'p63', name: 'Wijnaldum', position: 'CM'),
    Player(id: 'p64', name: 'Messi', position: 'RW'),
    Player(id: 'p65', name: 'Mbappé', position: 'ST'),
    Player(id: 'p66', name: 'Neymar', position: 'LW'),

    // Juventus players
    Player(id: 'p67', name: 'Szczęsny', position: 'GK'),
    Player(id: 'p68', name: 'Cuadrado', position: 'RB'),
    Player(id: 'p69', name: 'Bonucci', position: 'CB'),
    Player(id: 'p70', name: 'de Ligt', position: 'CB'),
    Player(id: 'p71', name: 'Alex Sandro', position: 'LB'),
    Player(id: 'p72', name: 'Locatelli', position: 'CDM'),
    Player(id: 'p73', name: 'Rabiot', position: 'CM'),
    Player(id: 'p74', name: 'McKennie', position: 'CM'),
    Player(id: 'p75', name: 'Chiesa', position: 'RW'),
    Player(id: 'p76', name: 'Vlahović', position: 'ST'),
    Player(id: 'p77', name: 'Di María', position: 'LW'),

    // Chelsea players
    Player(id: 'p78', name: 'Mendy', position: 'GK'),
    Player(id: 'p79', name: 'Reece James', position: 'RB'),
    Player(id: 'p80', name: 'Silva', position: 'CB'),
    Player(id: 'p81', name: 'Koulibaly', position: 'CB'),
    Player(id: 'p82', name: 'Chilwell', position: 'LB'),
    Player(id: 'p83', name: 'Kanté', position: 'CDM'),
    Player(id: 'p84', name: 'Mount', position: 'CM'),
    Player(id: 'p85', name: 'Kovačić', position: 'CM'),
    Player(id: 'p86', name: 'Ziyech', position: 'RW'),
    Player(id: 'p87', name: 'Havertz', position: 'ST'),
    Player(id: 'p88', name: 'Pulisic', position: 'LW'),

    // Arsenal players
    Player(id: 'p89', name: 'Ramsdale', position: 'GK'),
    Player(id: 'p90', name: 'Tomiyasu', position: 'RB'),
    Player(id: 'p91', name: 'Saliba', position: 'CB'),
    Player(id: 'p92', name: 'Magalhães', position: 'CB'),
    Player(id: 'p93', name: 'Tierney', position: 'LB'),
    Player(id: 'p94', name: 'Partey', position: 'CDM'),
    Player(id: 'p95', name: 'Ødegaard', position: 'CM'),
    Player(id: 'p96', name: 'Xhaka', position: 'CM'),
    Player(id: 'p97', name: 'Saka', position: 'RW'),
    Player(id: 'p98', name: 'Jesus', position: 'ST'),
    Player(id: 'p99', name: 'Martinelli', position: 'LW'),

    // Tottenham Hotspur players
    Player(id: 'p100', name: 'Lloris', position: 'GK'),
    Player(id: 'p101', name: 'Royal', position: 'RB'),
    Player(id: 'p102', name: 'Romero', position: 'CB'),
    Player(id: 'p103', name: 'Dier', position: 'CB'),
    Player(id: 'p104', name: 'Reguilón', position: 'LB'),
    Player(id: 'p105', name: 'Højbjerg', position: 'CDM'),
    Player(id: 'p106', name: 'Bentancur', position: 'CM'),
    Player(id: 'p107', name: 'Kulusevski', position: 'CM'),
    Player(id: 'p108', name: 'Richarlison', position: 'RW'),
    Player(id: 'p109', name: 'Harry Kane', position: 'ST'),
    Player(id: 'p110', name: 'Son', position: 'LW'),

    // Manchester United players
    Player(id: 'p111', name: 'David de Gea', position: 'GK'),
    Player(id: 'p112', name: 'Dalot', position: 'RB'),
    Player(id: 'p113', name: 'Lindelöf', position: 'CB'),
    Player(id: 'p114', name: 'Maguire', position: 'CB'),
    Player(id: 'p115', name: 'Shaw', position: 'LB'),
    Player(id: 'p116', name: 'Fernandes', position: 'CM'),
    Player(id: 'p117', name: 'Pogba', position: 'CM'),
    Player(id: 'p118', name: 'Sancho', position: 'RW'),
    Player(id: 'p119', name: 'Rashford', position: 'ST'),
    Player(id: 'p120', name: 'Ronaldo', position: 'LW'),
    Player(id: 'p121', name: 'Matic', position: 'CM'),

    
  ];

  static final List<Team> teams = [
    Team(
      id: 't1',
      name: 'Barcelona',
      playerIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9', 'p10', 'p11'],
    ),
    Team(
      id: 't2',
      name: 'Real Madrid',
      playerIds: ['p12', 'p13', 'p14', 'p15', 'p16', 'p17', 'p18', 'p19', 'p20', 'p21', 'p22'],
    ),
    Team(
      id: 't3',
      name: 'Liverpool',
      playerIds: ['p23', 'p24', 'p25', 'p26', 'p27', 'p28', 'p29', 'p30', 'p31', 'p32', 'p33'],
    ),
    Team(
      id: 't4',
      name: 'Manchester City',
      playerIds: ['p34', 'p35', 'p36', 'p37', 'p38', 'p39', 'p40', 'p41', 'p42', 'p43', 'p44'],
    ),
    Team(
      id: 't5',
      name: 'Bayern Munich',
      playerIds: ['p45', 'p46', 'p47', 'p48', 'p49', 'p50', 'p51', 'p52', 'p53', 'p54', 'p55'],
    ),
    Team(
      id: 't6',
      name: 'Paris Saint-Germain',
      playerIds: ['p56', 'p57', 'p58', 'p59', 'p60', 'p61', 'p62', 'p63', 'p64', 'p65', 'p66'],
    ),
    Team(
      id: 't7',
      name: 'Juventus',
      playerIds: ['p67', 'p68', 'p69', 'p70', 'p71', 'p72', 'p73', 'p74', 'p75', 'p76', 'p77'],
    ),
    Team(
      id: 't8',
      name: 'Chelsea',
      playerIds: ['p78', 'p79', 'p80', 'p81', 'p82', 'p83', 'p84', 'p85', 'p86', 'p87', 'p88'],
    ),
    Team(
      id: 't9',
      name: 'Arsenal',
      playerIds: ['p89', 'p90', 'p91', 'p92', 'p93', 'p94', 'p95', 'p96', 'p97', 'p98', 'p99'],
    ),
    Team(
      id: 't10',
      name: 'Manchester United',
      playerIds: ['p100', 'p101', 'p102', 'p103', 'p104', 'p105', 'p106', 'p107', 'p108', 'p109', 'p110'],
    ),
    Team(
      id: 't11',
      name: 'Tottenham Hotspur',
      playerIds: ['p111', 'p112', 'p113', 'p114', 'p115', 'p116', 'p117', 'p118', 'p119', 'p120', 'p121'],
    ),
    Team(
      id: 't12',
      name: 'Manchester United',
      playerIds: ['p122', 'p123', 'p124', 'p125', 'p126', 'p127', 'p128', 'p129', 'p130', 'p131', 'p132'],
    ),
    
  ];

  static final List<Match> matches = [
    Match(
      id: 'm1',
      teamId: 't1',
      opponent: 'PSG',
      date: '2023-04-10',
      startingLineupIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9', 'p10', 'p11'],
      formation: '4-3-3',
    ),
    Match(
      id: 'm2',
      teamId: 't2',
      opponent: 'Bayern Munich',
      date: '2023-04-12',
      startingLineupIds: ['p12', 'p13', 'p14', 'p15', 'p16', 'p17', 'p18', 'p19', 'p20', 'p21', 'p22'],
      formation: '4-4-2',
    ),
    Match(
      id: 'm3',
      teamId: 't3',
      opponent: 'Manchester City',
      date: '2023-04-14',
      startingLineupIds: ['p23', 'p24', 'p25', 'p26', 'p27', 'p28', 'p29', 'p30', 'p31', 'p32', 'p33'],
      formation: '3-5-2',
    ),
    Match(
      id: 'm4',
      teamId: 't4',
      opponent: 'Bayern Munich',
      date: '2023-04-16',
      startingLineupIds: ['p34', 'p35', 'p36', 'p37', 'p38', 'p39', 'p40', 'p41', 'p42', 'p43', 'p44'],
      formation: '4-3-3',
    ),
    Match(
      id: 'm5',
      teamId: 't5',
      opponent: 'Paris Saint-Germain',
      date: '2023-04-18',
      startingLineupIds: ['p45', 'p46', 'p47', 'p48', 'p49', 'p50', 'p51', 'p52', 'p53', 'p54', 'p55'],
      formation: '4-2-3-1',
    ),
    Match(
      id: 'm6',
      teamId: 't6',
      opponent: 'Juventus',
      date: '2023-04-20',
      startingLineupIds: ['p56', 'p57', 'p58', 'p59', 'p60', 'p61', 'p62', 'p63', 'p64', 'p65', 'p66'],
      formation: '3-4-3',
    ),
    Match(
      id: 'm7',
      teamId: 't7',
      opponent: 'Chelsea',
      date: '2023-04-22',
      startingLineupIds: ['p67', 'p68', 'p69', 'p70', 'p71', 'p72', 'p73', 'p74', 'p75', 'p76', 'p77'],
      formation: '4-3-3',
    ),
    Match(
      id: 'm8',
      teamId: 't8',
      opponent: 'Manchester United',
      date: '2023-04-24',
      startingLineupIds: ['p78', 'p79', 'p80', 'p81', 'p82', 'p83', 'p84', 'p85', 'p86', 'p87', 'p88'],
      formation: '4-4-2',
    ),
    Match(
      id: 'm9',
      teamId: 't9',
      opponent: 'Manchester United',
      date: '2023-04-26',
      startingLineupIds: ['p89', 'p90', 'p91', 'p92', 'p93', 'p94', 'p95', 'p96', 'p97', 'p98', 'p99'],
      formation: '4-3-3',
    ),
    Match(
      id: 'm10',
      teamId: 't10',
      opponent: 'Benfica',
      date: '2023-04-28',
      startingLineupIds: ['p100', 'p101', 'p102', 'p103', 'p104', 'p105', 'p106', 'p107', 'p108', 'p109', 'p110'],
      formation: '4-3-3',
    ),
    Match(
      id: 'm11',
      teamId: 't11',
      opponent: 'Manchester City',
      date: '2023-04-30',
      startingLineupIds: ['p111', 'p112', 'p113', 'p114', 'p115', 'p116', 'p117', 'p118', 'p119', 'p120', 'p121'],
      formation: '4-5-1',
    ),
    Match(
      id: 'm12',
      teamId: 't12',
      opponent: 'Porto',
      date: '2023-05-02',
      startingLineupIds: ['p122', 'p123', 'p124', 'p125', 'p126', 'p127', 'p128', 'p129', 'p130', 'p131', 'p132'],
      formation: '4-3-3',
    ),
  ];

  // Get a random match
  static Match getRandomMatch() {
    matches.shuffle();
    return matches.first;
  }

  // Get team by ID
  static Team getTeamById(String teamId) {
    return teams.firstWhere((team) => team.id == teamId);
  }

  // Get player by ID
  static Player getPlayerById(String playerId) {
    return players.firstWhere((player) => player.id == playerId);
  }

  // Get all players for a team
  static List<Player> getPlayersForTeam(String teamId) {
    final team = getTeamById(teamId);
    return team.playerIds.map((id) => getPlayerById(id)).toList();
  }

  // Get starting lineup for a match
  static List<Player> getStartingLineup(String matchId) {
    final match = matches.firstWhere((match) => match.id == matchId);
    return match.startingLineupIds.map((id) => getPlayerById(id)).toList();
  }
} 