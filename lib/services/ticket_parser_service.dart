import '../models/market.dart'; // 👈 Necesario para reconocer el tipo 'Market'
import '../parsers/market_parser.dart';

class TicketParserService {
  Market? parseMarket(String rawText) {
    return parseMarketFromText(rawText);
  }
}
