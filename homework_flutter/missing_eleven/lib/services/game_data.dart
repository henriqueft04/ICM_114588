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