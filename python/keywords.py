from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
import uuid
import jwt
import json

@keyword('Tulosta Json')
def tulosta_json(dict):
    '''
    Muotoile ja tulosta jsonina annettu dictionary.
    '''
    pretty_json = json.dumps(dict, indent=4)
    logger.info(pretty_json)
    return pretty_json


@keyword("Generoi UUID")
def generoi_uuid():
    '''
    Generoi ja palautetaan UUID muotoinen 36 merkkiä pitkän stringi
    '''
    return str(uuid.uuid4())

@keyword('Pura Ja Tarkista JWT')
def pura_jwt(token):
    '''
    Tarkasta annetun tokenin allekirjoituksen. Pura ja palauta JWT.
    '''
    public_key_path = BuiltIn().get_variable_value("${HSL_TICKET_PUBLIC_KEY}")
    public_key = open(public_key_path,"r")
    return jwt.decode(token, public_key.read(), options={"verify_iat": False}, algorithms=["RS256"])


@keyword('Korvaa Kielletyt Merkit')
def korvaa_kielletyt_merkit(str_in,kielletyt_merkit=[":"],uusi_merkki=' '):
    '''
    Korvaa ja palauta stringi, josta on korvattu kielletyt halutulla uudella merkillä.
    '''
    str_out = ''

    for char in str_in:
        if char in kielletyt_merkit:
            str_out = str_out + uusi_merkki
        else:
            str_out = str_out + char
    
    return str_out